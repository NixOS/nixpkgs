{
  buildPythonApplication,
  fetchFromGitHub,
  i3ipc,
  lib,
  poetry-core,
  writeScript,
}:

buildPythonApplication rec {
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

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    i3ipc
  ];

  passthru.updateScript = writeScript "update-${pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p git common-updater-scripts perl tomlq
    tmpdir="$(mktemp -d)"
    git clone --depth=1 "${src.gitRepoUrl}" "$tmpdir"
    pushd "$tmpdir"
    newVersionNumber=$(perl -ne 'print if s/version = "([\d.]+)"/$1/' pyproject.toml)
    newRevision=$(git show -s --pretty='format:%H')
    newDate=$(git show -s --pretty='format:%cs')
    newVersion="$newVersionNumber-unstable-$newDate"
    echo "newVersion = $newVersion" >&2
    echo "newRevision = $newRevision" >&2
    popd
    rm -rf "$tmpdir"
    update-source-version --rev="$newRevision" "${pname}" "$newVersion"
    perl -pe 's/^(.*version = ")([\d\.]+)(.*)$/''${1}'"''${newVersion}"'";/' \
      -i 'pkgs/applications/window-managers/i3/${pname}.nix'
  '';

  meta = with lib; {
    homepage = "https://github.com/LandingEllipse/kitti3";
    description = "Kitty drop-down service for sway & i3wm";
    mainProgram = "kitti3";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
