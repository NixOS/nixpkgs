# python library used to update plugins:
# - pkgs/applications/editors/vim/plugins/update.py
# - pkgs/applications/editors/kakoune/plugins/update.py
# - maintainers/scripts/update-luarocks-packages

# format:
# $ nix run nixpkgs#black maintainers/scripts/pluginupdate.py
# type-check:
# $ nix run nixpkgs#python3.pkgs.mypy maintainers/scripts/pluginupdate.py
# linted:
# $ nix run nixpkgs#python3.pkgs.flake8 -- --ignore E501,E265 maintainers/scripts/pluginupdate.py

import argparse
import csv
import functools
import http
import json
import logging
import os
import subprocess
import sys
import time
import traceback
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from dataclasses import asdict, dataclass
from datetime import UTC, datetime
from functools import wraps
from multiprocessing.dummy import Pool
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Any, Callable, Dict, List, Optional, Tuple, Union
from urllib.parse import urljoin, urlparse

import git

ATOM_ENTRY = "{http://www.w3.org/2005/Atom}entry"  # " vim gets confused here
ATOM_LINK = "{http://www.w3.org/2005/Atom}link"  # "
ATOM_UPDATED = "{http://www.w3.org/2005/Atom}updated"  # "

LOG_LEVELS = {
    logging.getLevelName(level): level
    for level in [logging.DEBUG, logging.INFO, logging.WARN, logging.ERROR]
}

log = logging.getLogger()


def retry(ExceptionToCheck: Any, tries: int = 4, delay: float = 3, backoff: float = 2):
    """Retry calling the decorated function using an exponential backoff.
    http://www.saltycrane.com/blog/2009/11/trying-out-retry-decorator-python/
    original from: http://wiki.python.org/moin/PythonDecoratorLibrary#Retry
    (BSD licensed)
    :param ExceptionToCheck: the exception on which to retry
    :param tries: number of times to try (not retry) before giving up
    :param delay: initial delay between retries in seconds
    :param backoff: backoff multiplier e.g. value of 2 will double the delay
        each retry
    """

    def deco_retry(f: Callable) -> Callable:
        @wraps(f)
        def f_retry(*args: Any, **kwargs: Any) -> Any:
            mtries, mdelay = tries, delay
            while mtries > 1:
                try:
                    return f(*args, **kwargs)
                except ExceptionToCheck as e:
                    print(f"{str(e)}, Retrying in {mdelay} seconds...")
                    time.sleep(mdelay)
                    mtries -= 1
                    mdelay *= backoff
            return f(*args, **kwargs)

        return f_retry  # true decorator

    return deco_retry


@dataclass
class FetchConfig:
    proc: int
    github_token: str


def make_request(url: str, token=None) -> urllib.request.Request:
    headers = {}
    if token is not None:
        headers["Authorization"] = f"token {token}"
    return urllib.request.Request(url, headers=headers)


# a dictionary of plugins and their new repositories
Redirects = Dict["PluginDesc", "Repo"]


class Repo:
    def __init__(self, uri: str, branch: str) -> None:
        self.uri = uri
        """Url to the repo"""
        self._branch = branch
        # Redirect is the new Repo to use
        self.redirect: Optional["Repo"] = None
        self.token = "dummy_token"

    @property
    def name(self):
        return self.uri.split("/")[-1]

    @property
    def branch(self):
        return self._branch or "HEAD"

    def __str__(self) -> str:
        return f"{self.uri}"

    def __repr__(self) -> str:
        return f"Repo({self.name}, {self.uri})"

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def has_submodules(self) -> bool:
        return True

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def latest_commit(self) -> Tuple[str, datetime]:
        log.debug("Latest commit")
        loaded = self._prefetch(None)
        updated = datetime.strptime(loaded["date"], "%Y-%m-%dT%H:%M:%S%z")

        return loaded["rev"], updated

    def _prefetch(self, ref: Optional[str]):
        cmd = ["nix-prefetch-git", "--quiet", "--fetch-submodules", self.uri]
        if ref is not None:
            cmd.append(ref)
        log.debug(cmd)
        data = subprocess.check_output(cmd)
        loaded = json.loads(data)
        return loaded

    def prefetch(self, ref: Optional[str]) -> str:
        print("Prefetching")
        loaded = self._prefetch(ref)
        return loaded["sha256"]

    def as_nix(self, plugin: "Plugin") -> str:
        return f"""fetchgit {{
      url = "{self.uri}";
      rev = "{plugin.commit}";
      sha256 = "{plugin.sha256}";
    }}"""


class RepoGitHub(Repo):
    def __init__(self, owner: str, repo: str, branch: str) -> None:
        self.owner = owner
        self.repo = repo
        self.token = None
        """Url to the repo"""
        super().__init__(self.url(""), branch)
        log.debug(
            "Instantiating github repo owner=%s and repo=%s", self.owner, self.repo
        )

    @property
    def name(self):
        return self.repo

    def url(self, path: str) -> str:
        res = urljoin(f"https://github.com/{self.owner}/{self.repo}/", path)
        return res

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def has_submodules(self) -> bool:
        try:
            req = make_request(self.url(f"blob/{self.branch}/.gitmodules"), self.token)
            urllib.request.urlopen(req, timeout=10).close()
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return False
            else:
                raise
        return True

    @retry(urllib.error.URLError, tries=4, delay=3, backoff=2)
    def latest_commit(self) -> Tuple[str, datetime]:
        commit_url = self.url(f"commits/{self.branch}.atom")
        log.debug("Sending request to %s", commit_url)
        commit_req = make_request(commit_url, self.token)
        with urllib.request.urlopen(commit_req, timeout=10) as req:
            self._check_for_redirect(commit_url, req)
            xml = req.read()
            root = ET.fromstring(xml)
            latest_entry = root.find(ATOM_ENTRY)
            assert latest_entry is not None, f"No commits found in repository {self}"
            commit_link = latest_entry.find(ATOM_LINK)
            assert commit_link is not None, f"No link tag found feed entry {xml}"
            url = urlparse(commit_link.get("href"))
            updated_tag = latest_entry.find(ATOM_UPDATED)
            assert (
                updated_tag is not None and updated_tag.text is not None
            ), f"No updated tag found feed entry {xml}"
            updated = datetime.strptime(updated_tag.text, "%Y-%m-%dT%H:%M:%SZ")
            return Path(str(url.path)).name, updated

    def _check_for_redirect(self, url: str, req: http.client.HTTPResponse):
        response_url = req.geturl()
        if url != response_url:
            new_owner, new_name = (
                urllib.parse.urlsplit(response_url).path.strip("/").split("/")[:2]
            )

            new_repo = RepoGitHub(owner=new_owner, repo=new_name, branch=self.branch)
            self.redirect = new_repo

    def prefetch(self, commit: str) -> str:
        if self.has_submodules():
            sha256 = super().prefetch(commit)
        else:
            sha256 = self.prefetch_github(commit)
        return sha256

    def prefetch_github(self, ref: str) -> str:
        cmd = ["nix-prefetch-url", "--unpack", self.url(f"archive/{ref}.tar.gz")]
        log.debug("Running %s", cmd)
        data = subprocess.check_output(cmd)
        return data.strip().decode("utf-8")

    def as_nix(self, plugin: "Plugin") -> str:
        if plugin.has_submodules:
            submodule_attr = "\n      fetchSubmodules = true;"
        else:
            submodule_attr = ""

        return f"""fetchFromGitHub {{
      owner = "{self.owner}";
      repo = "{self.repo}";
      rev = "{plugin.commit}";
      sha256 = "{plugin.sha256}";{submodule_attr}
    }}"""


@dataclass(frozen=True)
class PluginDesc:
    repo: Repo
    branch: str
    alias: Optional[str]

    @property
    def name(self):
        if self.alias is None:
            return self.repo.name
        else:
            return self.alias

    def __lt__(self, other):
        return self.repo.name < other.repo.name

    @staticmethod
    def load_from_csv(config: FetchConfig, row: Dict[str, str]) -> "PluginDesc":
        branch = row["branch"]
        repo = make_repo(row["repo"], branch.strip())
        repo.token = config.github_token
        return PluginDesc(repo, branch.strip(), row["alias"])

    @staticmethod
    def load_from_string(config: FetchConfig, line: str) -> "PluginDesc":
        branch = "HEAD"
        alias = None
        uri = line
        if " as " in uri:
            uri, alias = uri.split(" as ")
            alias = alias.strip()
        if "@" in uri:
            uri, branch = uri.split("@")
        repo = make_repo(uri.strip(), branch.strip())
        repo.token = config.github_token
        return PluginDesc(repo, branch.strip(), alias)


@dataclass
class Plugin:
    name: str
    commit: str
    has_submodules: bool
    sha256: str
    date: Optional[datetime] = None

    @property
    def normalized_name(self) -> str:
        return self.name.replace(".", "-")

    @property
    def version(self) -> str:
        assert self.date is not None
        return self.date.strftime("%Y-%m-%d")

    def as_json(self) -> Dict[str, str]:
        copy = self.__dict__.copy()
        del copy["date"]
        return copy


def load_plugins_from_csv(
    config: FetchConfig,
    input_file: Path,
) -> List[PluginDesc]:
    log.debug("Load plugins from csv %s", input_file)
    plugins = []
    with open(input_file, newline="") as csvfile:
        log.debug("Writing into %s", input_file)
        reader = csv.DictReader(
            csvfile,
        )
        for line in reader:
            plugin = PluginDesc.load_from_csv(config, line)
            plugins.append(plugin)

    return plugins



def run_nix_expr(expr, nixpkgs: str):
    '''
    :param expr nix expression to fetch current plugins
    :param nixpkgs Path towards a nixpkgs checkout
    '''
    with CleanEnvironment(nixpkgs) as nix_path:
        cmd = [
            "nix",
            "eval",
            "--extra-experimental-features",
            "nix-command",
            "--impure",
            "--json",
            "--expr",
            expr,
            "--nix-path",
            nix_path,
        ]
        log.debug("Running command: %s", " ".join(cmd))
        out = subprocess.check_output(cmd, timeout=90)
        data = json.loads(out)
        return data


class Editor:
    """The configuration of the update script."""

    def __init__(
        self,
        name: str,
        root: Path,
        get_plugins: str,
        default_in: Optional[Path] = None,
        default_out: Optional[Path] = None,
        deprecated: Optional[Path] = None,
        cache_file: Optional[str] = None,
    ):
        log.debug("get_plugins:", get_plugins)
        self.name = name
        self.root = root
        self.get_plugins = get_plugins
        self.default_in = default_in or root.joinpath(f"{name}-plugin-names")
        self.default_out = default_out or root.joinpath("generated.nix")
        self.deprecated = deprecated or root.joinpath("deprecated.json")
        self.cache_file = cache_file or f"{name}-plugin-cache.json"
        self.nixpkgs_repo = None

    def add(self, args):
        """CSV spec"""
        log.debug("called the 'add' command")
        fetch_config = FetchConfig(args.proc, args.github_token)
        editor = self
        for plugin_line in args.add_plugins:
            log.debug("using plugin_line", plugin_line)
            pdesc = PluginDesc.load_from_string(fetch_config, plugin_line)
            log.debug("loaded as pdesc", pdesc)
            append = [pdesc]
            editor.rewrite_input(
                fetch_config, args.input_file, editor.deprecated, append=append
            )
            plugin, _ = prefetch_plugin(
                pdesc,
            )
            autocommit = not args.no_commit
            if autocommit:
                commit(
                    editor.nixpkgs_repo,
                    "{drv_name}: init at {version}".format(
                        drv_name=editor.get_drv_name(plugin.normalized_name),
                        version=plugin.version,
                    ),
                    [args.outfile, args.input_file],
                )

    # Expects arguments generated by 'update' subparser
    def update(self, args):
        """CSV spec"""
        print("the update member function should be overriden in subclasses")

    def get_current_plugins(self, nixpkgs) -> List[Plugin]:
        """To fill the cache"""
        data = run_nix_expr(self.get_plugins, nixpkgs)
        plugins = []
        for name, attr in data.items():
            p = Plugin(name, attr["rev"], attr["submodules"], attr["sha256"])
            plugins.append(p)
        return plugins

    def load_plugin_spec(self, config: FetchConfig, plugin_file) -> List[PluginDesc]:
        """CSV spec"""
        return load_plugins_from_csv(config, plugin_file)

    def generate_nix(self, _plugins, _outfile: str):
        """Returns nothing for now, writes directly to outfile"""
        raise NotImplementedError()

    def get_update(self, input_file: str, outfile: str, config: FetchConfig):
        cache: Cache = Cache(self.get_current_plugins(self.nixpkgs), self.cache_file)
        _prefetch = functools.partial(prefetch, cache=cache)

        def update() -> dict:
            plugins = self.load_plugin_spec(config, input_file)

            try:
                pool = Pool(processes=config.proc)
                results = pool.map(_prefetch, plugins)
            finally:
                cache.store()

            plugins, redirects = check_results(results)

            self.generate_nix(plugins, outfile)

            return redirects

        return update

    @property
    def attr_path(self):
        return self.name + "Plugins"

    def get_drv_name(self, name: str):
        return self.attr_path + "." + name

    def rewrite_input(self, *args, **kwargs):
        return rewrite_input(*args, **kwargs)

    def create_parser(self):
        common = argparse.ArgumentParser(
            add_help=False,
            description=(
                f"""
                Updates nix derivations for {self.name} plugins.\n
                By default from {self.default_in} to {self.default_out}"""
            ),
        )
        common.add_argument(
            "--nixpkgs",
            type=str,
            default=os.getcwd(),
            help="Adjust log level",
        )
        common.add_argument(
            "--input-names",
            "-i",
            dest="input_file",
            type=Path,
            default=self.default_in,
            help="A list of plugins in the form owner/repo",
        )
        common.add_argument(
            "--out",
            "-o",
            dest="outfile",
            default=self.default_out,
            type=Path,
            help="Filename to save generated nix code",
        )
        common.add_argument(
            "--proc",
            "-p",
            dest="proc",
            type=int,
            default=30,
            help="Number of concurrent processes to spawn. Setting --github-token allows higher values.",
        )
        common.add_argument(
            "--github-token",
            "-t",
            type=str,
            default=os.getenv("GITHUB_API_TOKEN"),
            help="""Allows to set --proc to higher values.
            Uses GITHUB_API_TOKEN environment variables as the default value.""",
        )
        common.add_argument(
            "--no-commit",
            "-n",
            action="store_true",
            default=False,
            help="Whether to autocommit changes",
        )
        common.add_argument(
            "--debug",
            "-d",
            choices=LOG_LEVELS.keys(),
            default=logging.getLevelName(logging.WARN),
            help="Adjust log level",
        )

        main = argparse.ArgumentParser(
            parents=[common],
            description=(
                f"""
                Updates nix derivations for {self.name} plugins.\n
                By default from {self.default_in} to {self.default_out}"""
            ),
        )

        subparsers = main.add_subparsers(dest="command", required=False)
        padd = subparsers.add_parser(
            "add",
            parents=[],
            description="Add new plugin",
            add_help=False,
        )
        padd.set_defaults(func=self.add)
        padd.add_argument(
            "add_plugins",
            default=None,
            nargs="+",
            help=f"Plugin to add to {self.attr_path} from Github in the form owner/repo",
        )

        pupdate = subparsers.add_parser(
            "update",
            description="Update all or a subset of existing plugins",
            add_help=False,
        )
        pupdate.set_defaults(func=self.update)
        return main

    def run(
        self,
    ):
        """
        Convenience function
        """
        parser = self.create_parser()
        args = parser.parse_args()
        command = args.command or "update"
        log.setLevel(LOG_LEVELS[args.debug])
        log.info("Chose to run command: %s", command)
        self.nixpkgs = args.nixpkgs

        self.nixpkgs_repo = git.Repo(args.nixpkgs, search_parent_directories=True)

        getattr(self, command)(args)


class CleanEnvironment(object):
    def __init__(self, nixpkgs):
        self.local_pkgs = nixpkgs

    def __enter__(self) -> str:
        """
        local_pkgs = str(Path(__file__).parent.parent.parent)
        """
        self.old_environ = os.environ.copy()
        self.empty_config = NamedTemporaryFile()
        self.empty_config.write(b"{}")
        self.empty_config.flush()
        return f"localpkgs={self.local_pkgs}"

    def __exit__(self, exc_type: Any, exc_value: Any, traceback: Any) -> None:
        os.environ.update(self.old_environ)
        self.empty_config.close()


def prefetch_plugin(
    p: PluginDesc,
    cache: "Optional[Cache]" = None,
) -> Tuple[Plugin, Optional[Repo]]:
    repo, branch, alias = p.repo, p.branch, p.alias
    name = alias or p.repo.name
    commit = None
    log.info(f"Fetching last commit for plugin {name} from {repo.uri}@{branch}")
    commit, date = repo.latest_commit()
    cached_plugin = cache[commit] if cache else None
    if cached_plugin is not None:
        log.debug("Cache hit !")
        cached_plugin.name = name
        cached_plugin.date = date
        return cached_plugin, repo.redirect

    has_submodules = repo.has_submodules()
    log.debug(f"prefetch {name}")
    sha256 = repo.prefetch(commit)

    return (
        Plugin(name, commit, has_submodules, sha256, date=date),
        repo.redirect,
    )


def print_download_error(plugin: PluginDesc, ex: Exception):
    print(f"{plugin}: {ex}", file=sys.stderr)
    ex_traceback = ex.__traceback__
    tb_lines = [
        line.rstrip("\n")
        for line in traceback.format_exception(ex.__class__, ex, ex_traceback)
    ]
    print("\n".join(tb_lines))


def check_results(
    results: List[Tuple[PluginDesc, Union[Exception, Plugin], Optional[Repo]]]
) -> Tuple[List[Tuple[PluginDesc, Plugin]], Redirects]:
    """ """
    failures: List[Tuple[PluginDesc, Exception]] = []
    plugins = []
    redirects: Redirects = {}
    for pdesc, result, redirect in results:
        if isinstance(result, Exception):
            failures.append((pdesc, result))
        else:
            new_pdesc = pdesc
            if redirect is not None:
                redirects.update({pdesc: redirect})
                new_pdesc = PluginDesc(redirect, pdesc.branch, pdesc.alias)
            plugins.append((new_pdesc, result))

    print(f"{len(results) - len(failures)} plugins were checked", end="")
    if len(failures) == 0:
        print()
        return plugins, redirects
    else:
        print(f", {len(failures)} plugin(s) could not be downloaded:\n")

        for plugin, exception in failures:
            print_download_error(plugin, exception)

        sys.exit(1)


def make_repo(uri: str, branch) -> Repo:
    """Instantiate a Repo with the correct specialization depending on server (gitub spec)"""
    # dumb check to see if it's of the form owner/repo (=> github) or https://...
    res = urlparse(uri)
    if res.netloc in ["github.com", ""]:
        res = res.path.strip("/").split("/")
        repo = RepoGitHub(res[0], res[1], branch)
    else:
        repo = Repo(uri.strip(), branch)
    return repo


def get_cache_path(cache_file_name: str) -> Optional[Path]:
    xdg_cache = os.environ.get("XDG_CACHE_HOME", None)
    if xdg_cache is None:
        home = os.environ.get("HOME", None)
        if home is None:
            return None
        xdg_cache = str(Path(home, ".cache"))

    return Path(xdg_cache, cache_file_name)


class Cache:
    def __init__(self, initial_plugins: List[Plugin], cache_file_name: str) -> None:
        self.cache_file = get_cache_path(cache_file_name)

        downloads = {}
        for plugin in initial_plugins:
            downloads[plugin.commit] = plugin
        downloads.update(self.load())
        self.downloads = downloads

    def load(self) -> Dict[str, Plugin]:
        if self.cache_file is None or not self.cache_file.exists():
            return {}

        downloads: Dict[str, Plugin] = {}
        with open(self.cache_file) as f:
            data = json.load(f)
            for attr in data.values():
                p = Plugin(
                    attr["name"], attr["commit"], attr["has_submodules"], attr["sha256"]
                )
                downloads[attr["commit"]] = p
        return downloads

    def store(self) -> None:
        if self.cache_file is None:
            return

        os.makedirs(self.cache_file.parent, exist_ok=True)
        with open(self.cache_file, "w+") as f:
            data = {}
            for name, attr in self.downloads.items():
                data[name] = attr.as_json()
            json.dump(data, f, indent=4, sort_keys=True)

    def __getitem__(self, key: str) -> Optional[Plugin]:
        return self.downloads.get(key, None)

    def __setitem__(self, key: str, value: Plugin) -> None:
        self.downloads[key] = value


def prefetch(
    pluginDesc: PluginDesc, cache: Cache
) -> Tuple[PluginDesc, Union[Exception, Plugin], Optional[Repo]]:
    try:
        plugin, redirect = prefetch_plugin(pluginDesc, cache)
        cache[plugin.commit] = plugin
        return (pluginDesc, plugin, redirect)
    except Exception as e:
        return (pluginDesc, e, None)


def rewrite_input(
    config: FetchConfig,
    input_file: Path,
    deprecated: Path,
    # old pluginDesc and the new
    redirects: Redirects = {},
    append: List[PluginDesc] = [],
):
    plugins = load_plugins_from_csv(
        config,
        input_file,
    )

    plugins.extend(append)

    if redirects:
        cur_date_iso = datetime.now().strftime("%Y-%m-%d")
        with open(deprecated, "r") as f:
            deprecations = json.load(f)
        for pdesc, new_repo in redirects.items():
            new_pdesc = PluginDesc(new_repo, pdesc.branch, pdesc.alias)
            old_plugin, _ = prefetch_plugin(pdesc)
            new_plugin, _ = prefetch_plugin(new_pdesc)
            if old_plugin.normalized_name != new_plugin.normalized_name:
                deprecations[old_plugin.normalized_name] = {
                    "new": new_plugin.normalized_name,
                    "date": cur_date_iso,
                }
        with open(deprecated, "w") as f:
            json.dump(deprecations, f, indent=4, sort_keys=True)
            f.write("\n")

    with open(input_file, "w") as f:
        log.debug("Writing into %s", input_file)
        # fields = dataclasses.fields(PluginDesc)
        fieldnames = ["repo", "branch", "alias"]
        writer = csv.DictWriter(f, fieldnames, dialect="unix", quoting=csv.QUOTE_NONE)
        writer.writeheader()
        for plugin in sorted(plugins):
            writer.writerow(asdict(plugin))


def commit(repo: git.Repo, message: str, files: List[Path]) -> None:
    repo.index.add([str(f.resolve()) for f in files])

    if repo.index.diff("HEAD"):
        print(f'committing to nixpkgs "{message}"')
        repo.index.commit(message)
    else:
        print("no changes in working tree to commit")


def update_plugins(editor: Editor, args):
    """The main entry function of this module.
    All input arguments are grouped in the `Editor`."""

    log.info("Start updating plugins")
    fetch_config = FetchConfig(args.proc, args.github_token)
    update = editor.get_update(args.input_file, args.outfile, fetch_config)

    redirects = update()
    editor.rewrite_input(fetch_config, args.input_file, editor.deprecated, redirects)

    autocommit = not args.no_commit

    if autocommit:
        try:
            repo = git.Repo(os.getcwd())
            updated = datetime.now(tz=UTC).strftime('%Y-%m-%d')
            print(args.outfile)
            commit(repo,
                   f"{editor.attr_path}: update on {updated}", [args.outfile]
                   )
        except git.InvalidGitRepositoryError as e:
            print(f"Not in a git repository: {e}", file=sys.stderr)
            sys.exit(1)

    if redirects:
        update()
        if autocommit:
            commit(
                editor.nixpkgs_repo,
                f"{editor.attr_path}: resolve github repository redirects",
                [args.outfile, args.input_file, editor.deprecated],
            )
