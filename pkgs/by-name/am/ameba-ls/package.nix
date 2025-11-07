{
  lib,
  fetchFromGitHub,
  crystal_1_15,
  versionCheckHook,
}:

let
  # Use the same Crystal minor version as specified in upstream
  crystal = crystal_1_15;
in
crystal.buildCrystalPackage rec {
  pname = "ameba-ls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "crystal-lang-tools";
    repo = "ameba-ls";
    tag = "v${version}";
    hash = "sha256-TEHjR+34wrq24XJNLhWZCEzcDEMDlmUHv0iiF4Z6JlI=";
  };

  shardsFile = ./shards.nix;

  crystalBinaries.ameba-ls.src = "src/ameba-ls.cr";

  buildTargets = [
    "ameba-ls"
  ];

  # There are no actual tests
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm555 bin/ameba-ls -t "$out/bin/"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/ameba-ls";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Crystal language server powered by Ameba linter";
    homepage = "https://github.com/crystal-lang-tools/ameba-ls";
    changelog = "https://github.com/crystal-lang-tools/ameba-ls/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "ameba-ls";
  };
}
