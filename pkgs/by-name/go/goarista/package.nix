{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "goarista";
  version = "0-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "aristanetworks";
    repo = "goarista";
    rev = "2af7f36a2220911d96d9d5cf8dee641a7c01eb07";
    hash = "sha256-M/gZVn4ioaxRwbqlee3yeRfWIjaG6mFq2Z+XL5mGjoA=";
  };

  vendorHash = "sha256-5vdVHTQOXsYc8EdEGEAXk2ZX/6o88gHxBzfwETcwXvA=";

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
