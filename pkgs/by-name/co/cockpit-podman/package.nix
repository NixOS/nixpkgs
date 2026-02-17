{
  lib,
  stdenv,
  cockpit,
  nodejs,
  gettext,
  writeShellScriptBin,
  fetchFromGitHub,
  gitUpdater,
  podman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cockpit-podman";
  version = "120";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit-podman";
    tag = finalAttrs.version;
    hash = "sha256-1PXz+zHuj5fjzDe194+sgBlLhQnS9jzv9FbM9RfNIVc=";

    fetchSubmodules = true;
    postFetch = "cp $out/node_modules/.package-lock.json $out/package-lock.json";
  };

  buildInputs = [
    nodejs
    gettext
    (writeShellScriptBin "git" "true")
  ];

  cockpitSrc = cockpit.src;

  postPatch = ''
    mkdir -p pkg; cp -r $cockpitSrc/pkg/lib pkg
    mkdir -p test; cp -r $cockpitSrc/test/common test

    substituteInPlace Makefile \
      --replace-fail '$(MAKE) package-lock.json' 'true' \
      --replace-fail '$(COCKPIT_REPO_FILES) | tar x' "" \
      --replace-fail '/usr/local' "$out"

    substituteInPlace src/manifest.json \
      --replace-fail '"/lib/systemd' '"/run/current-system/sw/lib/systemd'

    patchShebangs build.js
  '';

  passthru = {
    updateScript = gitUpdater { };
    cockpitPath = [ podman ];
  };

  meta = {
    description = "Cockpit UI for podman containers";
    homepage = "https://github.com/cockpit-project/cockpit-podman";
    changelog = "https://github.com/cockpit-project/cockpit-podman/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ];
    teams = [ lib.teams.cockpit ];
  };
})
