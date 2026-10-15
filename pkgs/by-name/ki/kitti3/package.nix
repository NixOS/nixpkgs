{
  python3Packages,
  fetchFromGitHub,
  lib,
  writeScript,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kitti3";
  version = "0.5.1-unstable-2021-09-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LandingEllipse";
    repo = "kitti3";
    rev = "f9f94c8b9f8b61a9d085206ada470cfe755a2a92";
    hash = "sha256-bcIzbDpIe2GKS9EcVqpjwz0IG2ixNMn06OIQpZ7PeH0=";
  };

  patches = [
    # Fixes `build-system` not being specified in `pyproject.toml`
    # https://github.com/LandingEllipse/kitti3/pull/25
    ./kitti3-fix-build-system.patch
  ];

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [
    python3Packages.i3ipc
  ];

  passthru.updateScript = writeScript "update-kitti3" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p git common-updater-scripts perl tomlq
    tmpdir="$(mktemp -d)"
    trap "rm -rf $tmpdir" EXIT
    git clone --depth=1 "${finalAttrs.src.gitRepoUrl}" "$tmpdir"
    pushd "$tmpdir"
    newVersionNumber=$(perl -ne 'print if s/version = "([\d.]+)"/$1/' pyproject.toml)
    newRevision=$(git show -s --pretty='format:%H')
    newDate=$(git show -s --pretty='format:%cs')
    newVersion="$newVersionNumber-unstable-$newDate"
    echo "newVersion = $newVersion" >&2
    echo "newRevision = $newRevision" >&2
    popd
    update-source-version --rev="$newRevision" "kitti3" "$newVersion"
    perl -pe 's/^(.*version = ")([\d\.]+)(.*)$/''${1}'"''${newVersion}"'";/' \
      -i 'pkgs/applications/window-managers/i3/kitti3.nix'
  '';

  meta = {
    homepage = "https://github.com/LandingEllipse/kitti3";
    description = "Kitty drop-down service for sway & i3wm";
    mainProgram = "kitti3";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
