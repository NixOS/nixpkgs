import collections
import dataclasses
import functools
import json
import pathlib
import subprocess

import yaml

class DataclassEncoder(json.JSONEncoder):
    def default(self, it):
        if dataclasses.is_dataclass(it):
            return dataclasses.asdict(it)
        return super().default(it)


@dataclasses.dataclass
class Project:
    name: str
    description: str | None
    project_path: str
    repo_path: str | None

    def __hash__(self) -> int:
        return hash(self.name)

    @classmethod
    def from_yaml(cls, path: pathlib.Path):
        data = yaml.safe_load(path.open())
        return cls(
            name=data["identifier"],
            description=data["description"],
            project_path=data["projectpath"],
            repo_path=data["repopath"]
        )


def get_git_commit(path: pathlib.Path):
    return subprocess.check_output(["git", "-C", path, "rev-parse", "--short", "HEAD"]).decode().strip()


def validate_unique(projects: list[Project], attr: str):
    seen = set()
    for item in projects:
        attr_value = getattr(item, attr)
        if attr_value in seen:
            raise Exception(f"Duplicate {attr}: {attr_value}")
        seen.add(attr_value)


THIRD_PARTY = {
    "third-party/appstream": "appstream-qt",
    "third-party/cmark": "cmark",
    "third-party/gpgme": "gpgme",
    "third-party/kdsoap": "kdsoap",
    "third-party/libaccounts-qt": "accounts-qt",
    "third-party/libgpg-error": "libgpg-error",
    "third-party/libquotient": "libquotient",
    "third-party/packagekit-qt": "packagekit-qt",
    "third-party/poppler": "poppler",
    "third-party/qcoro": "qcoro",
    "third-party/qmltermwidget": "qmltermwidget",
    "third-party/qtkeychain": "qtkeychain",
    "third-party/signond": "signond",
    "third-party/taglib": "taglib",
    "third-party/wayland-protocols": "wayland-protocols",
    "third-party/wayland": "wayland",
    "third-party/zxing-cpp": "zxing-cpp",
}

IGNORE = {
    "kdesupport/phonon-directshow",
    "kdesupport/phonon-mmf",
    "kdesupport/phonon-mplayer",
    "kdesupport/phonon-quicktime",
    "kdesupport/phonon-waveout",
    "kdesupport/phonon-xine"
}

WARNED = set()


@dataclasses.dataclass
class KDERepoMetadata:
    version: str
    projects: list[Project]
    dep_graph: dict[Project, set[Project]]

    @functools.cached_property
    def projects_by_name(self):
        return {p.name: p for p in self.projects}

    @functools.cached_property
    def projects_by_path(self):
        return {p.project_path: p for p in self.projects}

    def try_lookup_package(self, path):
        if path in IGNORE:
            return None
        project = self.projects_by_path.get(path)
        if project is None and path not in WARNED:
            WARNED.add(path)
            print(f"Warning: unknown project {path}")
        return project

    @classmethod
    def from_repo_metadata_checkout(cls, repo_metadata: pathlib.Path, unstable=False):
        projects = [
            Project.from_yaml(metadata_file)
            for metadata_file in repo_metadata.glob("projects-invent/**/metadata.yaml")
        ] + [
            Project(id, None, project_path, None)
            for project_path, id in THIRD_PARTY.items()
        ]

        validate_unique(projects, "name")
        validate_unique(projects, "project_path")

        self = cls(
            version=get_git_commit(repo_metadata),
            projects=projects,
            dep_graph={},
        )

        dep_graph = collections.defaultdict(set)

        if unstable:
            spec_name = "dependency-data-kf6-qt6"
        else:
            spec_name = "dependency-data-stable-kf6-qt6"

        spec_path = repo_metadata / "dependencies" / spec_name
        for line in spec_path.open():
            line = line.strip()
            if line.startswith("#"):
                continue
            if not line:
                continue

            dependent, dependency = line.split(": ")

            dependent = self.try_lookup_package(dependent)
            if dependent is None:
                continue

            dependency = self.try_lookup_package(dependency)
            if dependency is None:
                continue

            dep_graph[dependent].add(dependency)

        self.dep_graph = dep_graph

        return self

    def write_json(self, root: pathlib.Path):
        root.mkdir(parents=True, exist_ok=True)

        with (root / "projects.json").open("w") as fd:
            json.dump(self.projects_by_name, fd, cls=DataclassEncoder, sort_keys=True, indent=2)

        with (root / "dependencies.json").open("w") as fd:
            deps = {k.name: sorted(dep.name for dep in v) for k, v in self.dep_graph.items()}
            json.dump({"version": self.version, "dependencies": deps}, fd, cls=DataclassEncoder, sort_keys=True, indent=2)

    @classmethod
    def from_json(cls, root: pathlib.Path):
        projects = [
            Project(**v) for v in json.load((root / "projects.json").open()).values()
        ]

        deps = json.load((root / "dependencies.json").open())
        self = cls(
            version=deps["version"],
            projects=projects,
            dep_graph={},
        )

        dep_graph = collections.defaultdict(set)
        for dependent, dependencies in deps["dependencies"].items():
            for dependency in dependencies:
                dep_graph[self.projects_by_name[dependent]].add(self.projects_by_name[dependency])

        self.dep_graph = dep_graph
        return self
