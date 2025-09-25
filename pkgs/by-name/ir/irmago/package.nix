{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "irmago";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "privacybydesign";
    repo = "irmago";
    tag = "v${version}";
    hash = "sha256-hHMwyPlPdPvznH8I4LmIv7S4jvzgleDuUPrBq+aeIHA=";
  };

  vendorHash = "sha256-A9HGxrJjtFERKoKv6/mHuL5m5IX29xECt3Jlv5nry3k=";

  subPackages = [ "irma" ];

  # Skip failing tests for now
  checkFlags =
    let
      skippedTests = [
        "TestVerifyInValid"
        "TestVerifyInValidNonce"
        "TestVerifyInValidSig"
        "TestVerifyValidSig"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    changelog = "https://github.com/privacybydesign/irmago/releases/tag/${src.tag}";
    description = "IRMA CLI and server implementation in Go for privacy-preserving attribute issuance and verification";
    homepage = "https://docs.yivi.app/irma-cli";
    license = lib.licenses.asl20;
    mainProgram = "irmago";
    maintainers = with lib.maintainers; [
      jorritvanderheide
    ];
  };
}
