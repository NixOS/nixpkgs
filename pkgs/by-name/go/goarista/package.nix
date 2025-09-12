{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goarista";
  version = "0-unstable-2025-09-01";

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "goarista";
    rev = "4c0e3d6d22a8b50c5a7e107011bbd843ea3a1f76";
    hash = "sha256-S1RKLcLhy8gPQlbJM4txOCqNWVHQOlJq2zY4Rdhfdls=";
  };

  vendorHash = "sha256-n+P3L3dT2kYuTyI2qX/nrLRgFIUsP3kkwNZmRQ8EFRs=";

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
