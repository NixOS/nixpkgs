{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Dependencies
  aria2,
  # Java Script dependency
  nodejs,
  fetchNpmDeps,
  npmHooks,
  # Updater
  nix-update-script,
}:

melpaBuild (finalAttrs: {

  pname = "eaf-browser";
  version = "0-unstable-2025-06-14";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-browser";
    rev = "120967319132f361a2b27f89ee54d1984aa23eaf";
    hash = "sha256-DsPrctB1bSGBPQLI2LsnSUtqnzWpZRrWrVZM8lS9fms=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-UfQL7rN47nI1FyhgBlzH4QtyVCn0wGV3Rv5Y+aidRNE=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  files = ''
    ("*.el"
     "*.py"
     "easylist.txt"
     "aria2-ng")
  '';

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp/elpa/${finalAttrs.ename}-${finalAttrs.melpaVersion}
    cp -r node_modules $LISPDIR/
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    eafPythonDeps =
      ps: with ps; [
        pysocks
      ];
    eafOtherDeps = [
      aria2
    ];
  };

  meta = {
    description = "Modern browser in Emacs";
    homepage = "https://github.com/emacs-eaf/eaf-browser";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
