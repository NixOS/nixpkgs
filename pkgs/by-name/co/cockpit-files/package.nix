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
  pname = "cockpit-files";
  version = "35";

  src = fetchFromGitHub {
    owner = "cockpit-project";
    repo = "cockpit-files";
    tag = finalAttrs.version;
    hash = "sha256-ziFtsWZPdzkqc3UEaoIfwsIe8q/H0lyLtEropA2w+pc=";

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

    patchShebangs build.js
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Featureful file browser for Cockpit";
    homepage = "https://github.com/cockpit-project/cockpit-files";
    changelog = "https://github.com/cockpit-project/cockpit-files/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.lgpl21 ];
    teams = [ lib.teams.cockpit ];
  };
})
