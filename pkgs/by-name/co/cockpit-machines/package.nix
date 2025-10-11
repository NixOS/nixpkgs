{
  lib,
  stdenv,
  cockpit,
  nodejs,
  gettext,
  writeShellScriptBin,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cockpit-machines";
  version = "341";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit-machines";
    tag = finalAttrs.version;
    hash = "sha256-ppNN5XiIpu7ajJXh/4hntaD0/FSnAwLaTzStOigtM/A=";

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
      --replace-fail '"/usr/share' '"/run/current-system/sw/share'

    patchShebangs build.js
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Cockpit UI for virtual machines";
    homepage = "https://github.com/cockpit-project/cockpit-machines";
    changelog = "https://github.com/cockpit-project/cockpit-machines/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ];
    teams = [ lib.teams.cockpit ];
  };
})
