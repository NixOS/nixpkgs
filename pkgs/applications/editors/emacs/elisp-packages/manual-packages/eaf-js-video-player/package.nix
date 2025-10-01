{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # JavaScript dependency
  nodejs,
  fetchNpmDeps,
  npmHooks,
  # Updater
  nix-update-script,
}:

melpaBuild (finalAttrs: {

  pname = "eaf-js-video-player";
  version = "0-unstable-2025-07-26";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-js-video-player";
    rev = "6e4e938c42b265e108a0474a22813322ff2db124";
    hash = "sha256-tyovHnVX1kkom8W56GI/+PfaQSoCiB4OJj535Dbzah0=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-grLuq11Sgx6jYCDjWch1AYuL8d/NCsr9BmAPvEgrfG8=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postBuild = ''
    npm run build
  '';

  files = ''
    ("*.el"
     "*.py"
     "*.js"
     "src")
  '';

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp/elpa/${finalAttrs.ename}-${finalAttrs.melpaVersion}
    touch node_modules/.nosearch
    cp -r node_modules $LISPDIR/
    cp -r dist $LISPDIR/
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    eafPythonDeps = ps: [ ];
    eafOtherDeps = [ ];
  };

  meta = {
    description = "EAF Video Player (JS) application";
    homepage = "https://github.com/emacs-eaf/eaf-js-video-player";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
