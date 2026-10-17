{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goarista";
  version = "untagged-ac532b8620c4bd49962c-unstable-2026-09-27";

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "goarista";
    rev = "aaff1a13d702c35eba8df1cab3d7973ff828e139";
    hash = "sha256-x1X8mjZDGR/RwIITo56BrQO1qmI67t0aR1WTEJ0W3io=";
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
