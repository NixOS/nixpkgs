{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Dependencies
  fd,
  # JavaScript dependency
  nodejs,
  fetchNpmDeps,
  npmHooks,
  # Updater
  nix-update-script,
}:

melpaBuild (finalAttrs: {

  pname = "eaf-file-manager";
  version = "0-unstable-2025-03-23";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-file-manager";
    rev = "57f2e8a7f6282fbb4689b3fc8b99458ed3667dc6";
    hash = "sha256-IET9b3nS/Z4dxqFVyNITVoMDo6E/+sm3E7cfO7pozRo=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-dzfw+CgoM1CulPoa0KEzUX9dlBiquX4BkYNwU3vMb+Q=";
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
    eafPythonDeps =
      ps: with ps; [
        pypinyin
        pygments
        exif
      ];
    eafOtherDeps = [
      fd
    ];
  };

  meta = {
    description = "File manager application for the EAF";
    homepage = "https://github.com/emacs-eaf/eaf-file-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
