{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goarista";
  version = "untagged-ac532b8620c4bd49962c-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "goarista";
    rev = "837a77d26d80521530e09dfe477ad4611c2635f1";
    hash = "sha256-M8zW2c3cwFxfviAFWOXf8adBFoPJQQBCG0jKNmsUNYw=";
  };

  vendorHash = "sha256-MN9npxcsvHOC1HokR9JxTZl5cxF2hyzxSiNoB5/jaJo=";

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
