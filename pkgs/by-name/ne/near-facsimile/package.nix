{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "near-facsimile";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "msuchane";
    repo = "near-facsimile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JJoouEIccTEQtS8FliBEQr4zPcIqSt9PtAxAch5mOG0=";
  };

  cargoHash = "sha256-w6Diqvti8BJFk1OHIVP1cjez3KYFwShMqv1/f4oUnrI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find similar or identical text files in a directory";
    homepage = "https://github.com/msuchane/near-facsimile";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "near-facsimile";
  };
})
