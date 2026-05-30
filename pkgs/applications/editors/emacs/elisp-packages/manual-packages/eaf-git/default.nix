{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # Dependencies
  delta,
  ripgrep,
  # JavaScript dependency
  nodejs,
  fetchNpmDeps,
  npmHooks,
  # Updater
  nix-update-script,
}:

melpaBuild (finalAttrs: {

  pname = "eaf-git";
  version = "0-unstable-2025-07-10";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-git";
    rev = "24c3887075630a21d0a53ddb95b01ef70694f03a";
    hash = "sha256-ggxgwMTk46WDLKxrNkzX3pSO/yLoLTJVH08T4o70fEM=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-kbFnPZlFqoE1Q/KKVW5ZI4HPPWsIjXA/jne2jw7BeEc=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postPatch = ''
    substituteInPlace eaf-git.el \
      --replace-fail "(defcustom eaf-git-delta-executable \"delta\"" \
                     "(defcustom eaf-git-delta-executable \"${lib.getExe delta}\""

    substituteInPlace buffer.py \
      --replace-fail "command = \"rg '{}' {}" \
                     "command = \"${lib.getExe ripgrep} '{}' {}"
  '';

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
        charset-normalizer
        giturlparse
        pygit2
        pygments
        unidiff
      ];
  };

  meta = {
    description = "Git client for the EAF";
    homepage = "https://github.com/emacs-eaf/eaf-git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
