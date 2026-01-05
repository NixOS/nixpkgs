{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "1.6.1";
in
buildGoModule {
  pname = "ktunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "omrikiei";
    repo = "ktunnel";
    rev = "v${version}";
    sha256 = "sha256-rcUCIUIyBCSuMly7y0GUNQCdJUgsj7Oi6Hpz23uXoJw=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-Q8t/NWGeUB1IpxdsxvyvbYh/adtcA4p+7bcCy9YFjsw=";

  preCheck = "export HOME=$(mktemp -d)";

  # # TODO investigate why some tests are failing
  doCheck = false;

  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ktunnel" --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Cli that exposes your local resources to kubernetes";
    mainProgram = "ktunnel";
    homepage = "https://github.com/omrikiei/ktunnel";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
