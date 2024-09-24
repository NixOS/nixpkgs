import json
import os
import pathlib
import requests
import shutil
import subprocess
import sys
import tempfile


def replace_in_file(file_path, replacements):
    file_contents = pathlib.Path(file_path).read_text()
    for old, new in replacements.items():
        if old == new:
            continue
        updated_file_contents = file_contents.replace(old, new)
        # A dumb way to check that we’ve actually replaced the string.
        if file_contents == updated_file_contents:
            print(f"no string to replace: {old} → {new}", file=sys.stderr)
            sys.exit(1)
        file_contents = updated_file_contents
    with tempfile.NamedTemporaryFile(mode="w") as t:
        t.write(file_contents)
        t.flush()
        shutil.copyfile(t.name, file_path)


def nix_hash_to_sri(hash):
    return subprocess.run(
        [
            "nix",
            "--extra-experimental-features", "nix-command",
            "hash",
            "to-sri",
            "--type", "sha256",
            "--",
            hash,
        ],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.rstrip()


nixpkgs_path = "."

package_attrs_expr = """nixpkgsFun:
let
  pkgs = nixpkgsFun { };
  inherit (pkgs.dotnetCorePackages) systemToDotnetRid;
  p = pkgs.sonarr;
in
{
  dir = builtins.dirOf p.meta.position;
  version = p.version;
  sourceHash = p.src.outputHash;
  yarnHash = p.yarnOfflineCache.outputHash;
  projects = p.dotnetProjectFiles ++ p.dotnetTestProjectFiles;
  runtimes = map systemToDotnetRid p.meta.platforms;
  dotnetFlags = p.dotnetFlags;
}"""
package_attrs = json.loads(subprocess.run(
    [
        "nix",
        "--extra-experimental-features", "nix-command",
        "eval",
        "--json",
        "--file", nixpkgs_path,
        "--apply", package_attrs_expr,
    ],
    stdout=subprocess.PIPE,
    text=True,
    check=True,
).stdout)

old_version = package_attrs["version"]
new_version = old_version

# Note that we use Sonarr API instead of GitHub to fetch latest stable release.
# This corresponds to the Updates tab in the web UI. See also
# https://github.com/Sonarr/Sonarr/blob/070919a7e6a96ca7e26524996417c6f8d1b5fcaa/src/NzbDrone.Core/Update/UpdatePackageProvider.cs
version_update = requests.get(
    f"https://services.sonarr.tv/v1/update/main?version={old_version}",
).json()
if version_update["available"]:
    new_version = version_update["updatePackage"]["version"]

if new_version == old_version:
    sys.exit()

print(f"Running nix-prefetch-url for Sonarr v{new_version}")
source_nix_hash, source_store_path = subprocess.run(
    [
        "nix-prefetch-url",
        "--name", "source",
        "--unpack",
        "--print-path",
        f"https://github.com/Sonarr/Sonarr/archive/v{new_version}.tar.gz",
    ],
    stdout=subprocess.PIPE,
    text=True,
    check=True,
).stdout.rstrip().split("\n")

old_source_hash = package_attrs["sourceHash"]
new_source_hash = nix_hash_to_sri(source_nix_hash)

print("Running prefetch-yarn-deps")
old_yarn_hash = package_attrs["yarnHash"]
new_yarn_hash = nix_hash_to_sri(subprocess.run(
    [
        "prefetch-yarn-deps",
        # does not support "--" separator :(
        # Also --verbose writes to stdout, yikes.
        os.path.join(source_store_path, "yarn.lock"),
    ],
    stdout=subprocess.PIPE,
    text=True,
    check=True,
).stdout.rstrip())

package_dir = package_attrs["dir"]
package_projects = package_attrs["projects"]
package_runtimes = package_attrs["runtimes"]
package_file_name = "package.nix"
deps_file_name = "deps.nix"

dotnet_flags = package_attrs["dotnetFlags"]

# Generate nuget-to-nix dependency lock file.
with tempfile.TemporaryDirectory() as work_dir:
    # Copy projects source tree without permissions / file mode.
    source_path = os.path.join(work_dir, "src")
    shutil.copytree(os.path.join(source_store_path, "src"), source_path,
                    copy_function=shutil.copyfile)

    nuget_packages = os.path.join(work_dir, "packages")
    temp_path = os.path.join(work_dir, "obj")
    cache_path = os.path.join(work_dir, "http-cache")

    for runtime in package_runtimes:
        for project in package_projects:
            print(f"Running dotnet restore --runtime {runtime} {project}")
            subprocess.run(
                [
                    "dotnet",
                    "restore",
                    "--property:ContinuousIntegrationBuild=true",
                    "--property:Deterministic=true",
                    "--property:NuGetAudit=false",
                    f"--runtime={runtime}",
                    f"--packages={nuget_packages}",
                    *dotnet_flags,
                    project,
                ],
                env={
                    **os.environ,
                    "DOTNET_NOLOGO": "1",
                    "DOTNET_CLI_TELEMETRY_OPTOUT": "1",
                    "MSBUILDDISABLENODEREUSE": "1",
                    "NUGET_HTTP_CACHE_PATH": cache_path,
                },
                cwd=work_dir,
                check=True,
            )

    with tempfile.NamedTemporaryFile(mode="w") as t:
        t.write("# Code generated by passthru.updateScript. DO NOT EDIT.\n\n")
        t.flush()
        print("Running nuget-to-nix")
        subprocess.run(
            [
                "nuget-to-nix",
                nuget_packages,
            ],
            stdout=t,
            cwd=source_path,
            check=True,
        )
        shutil.copyfile(t.name, os.path.join(package_dir, deps_file_name))

replace_in_file(os.path.join(package_dir, package_file_name), {
    # NB unlike hashes, versions are likely to be used in code or comments.
    # Try to be more specific to avoid false positive matches.
    f"version = \"{old_version}\"": f"version = \"{new_version}\"",
    old_source_hash: new_source_hash,
    old_yarn_hash: new_yarn_hash,
})
