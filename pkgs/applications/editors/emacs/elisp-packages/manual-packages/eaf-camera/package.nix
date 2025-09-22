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

  pname = "eaf-camera";
  version = "0-unstable-2025-03-09";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-camera";
    rev = "264e34489c175d25a9611446ad82a1d1adbfb896";
    hash = "sha256-tw4OA1Sbvj3eqm3B4Ou6Gxk3wegmS7wMy2/U+UGTCcY=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-MmNg4Qf1UhtUIpHjCcwk9MB59XGRhW9SzhO4yUcW1Ik=";
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
    description = "Camera application for the EAF";
    homepage = "https://github.com/emacs-eaf/eaf-camera";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
