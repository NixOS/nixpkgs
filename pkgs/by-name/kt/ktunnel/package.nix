{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.0.2";
in
buildGoModule {
  pname = "ktunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "omrikiei";
    repo = "ktunnel";
    rev = "v${version}";
    sha256 = "sha256-SJ6WCLJLKVODVsvPQUngV0oz60dpFT1mRDLNaeJ6P7M=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-9RT5NtsuhFGXHYoP9YFrNfQQlbeu1DB7gDkKgTn5z7g=";

  preCheck = "export HOME=$(mktemp -d)";

  # # TODO investigate why some tests are failing
  doCheck = false;

  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ktunnel" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Cli that exposes your local resources to kubernetes";
    mainProgram = "ktunnel";
    homepage = "https://github.com/omrikiei/ktunnel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
