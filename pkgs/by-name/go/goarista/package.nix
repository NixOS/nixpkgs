{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goarista";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "goarista";
    rev = "a373d7c9f0d9de57f4e1fcfe9adc868c7104f9cd";
    hash = "sha256-WxMo2cMYsorJ2aYNc2DAjxXYLh2CHJqbtGjJYtl2r68=";
  };

  vendorHash = "sha256-LS99/DKKh+KHtbI5n8/Dw47Le5qowRQYLuCA+Apwi8I=";

  passthru.updateScript = ./update.sh;

  checkFlags =
    let
      skippedTests = [
        "TestDeepSizeof"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ "TestDialTCPTimeoutWithTOS" ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Collection of open-source tools for network management and monitoring mostly based around gNMI";
    homepage = "https://github.com/aristanetworks/goarista";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "gnmi";
  };
}
