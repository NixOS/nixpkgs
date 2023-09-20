{ stdenv, lib, buildGoModule, fetchFromGitHub }:
let
  version = "1.5.3";
in
buildGoModule {
  pname = "ktunnel";
  inherit version;

  src = fetchFromGitHub {
    owner  = "omrikiei";
    repo   = "ktunnel";
    rev    = "v${version}";
    sha256 = "sha256-7SWj9Emm78xpzdvJFKqpI5HVQi0ohbixkgXKGTy5C/A=";
  };

  ldflags = [
    "-s" "-w"
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
    description = "A cli that exposes your local resources to kubernetes ";
    homepage = "https://github.com/omrikiei/ktunnel";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
