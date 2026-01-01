{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fblog";
  version = "4.17.0";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.16.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fblog";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-SDOYW9CpC7E62nVnZL04Kx9ckVEZyvcMolJCfKDqdMk=";
  };

  cargoHash = "sha256-Pn8HsBz+5OHz4jF6xmORLQSLYClTHpaJXWiS5sPyV2w=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    changelog = "https://github.com/brocode/fblog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
=======
    rev = "v${version}";
    hash = "sha256-SWwk7qNe2R1aBYGBFqltUZjeOvr4jG1P7/CPIAfHCc8=";
  };

  cargoHash = "sha256-du9FXuUNqQm1AMqcCFqeso5OPrPCxzTVl5e7kR0rpwc=";

  meta = with lib; {
    description = "Small command-line JSON log viewer";
    mainProgram = "fblog";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
