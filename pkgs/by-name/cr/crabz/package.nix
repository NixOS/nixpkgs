{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crabz";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "crabz";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/zck6MwPPlpd3OxKBoAdOE2gs5XLRU4QErLd0c7enDU=";
  };

  cargoHash = "sha256-STI0sVFtvKEhkBhtrjk7y2EzzbSQCk/631At2yHEnNM=";

  nativeBuildInputs = [ cmake ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      unlicense # or
      mit
    ];
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "crabz";
  };
})
