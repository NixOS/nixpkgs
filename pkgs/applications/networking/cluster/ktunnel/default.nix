{ stdenv, lib, buildGoModule, fetchFromGitHub }:
let
  version = "1.4.8";
in
buildGoModule {
  pname = "ktunnel";
  inherit version;

  src = fetchFromGitHub {
    owner  = "omrikiei";
    repo   = "ktunnel";
    rev    = "v${version}";
    sha256 = "sha256-Iw7Z4iuKxmRrS51KP3k/ouXW4xssdNgxDDzNQR2Zygg=";
  };

  ldflags = [
    "-s" "-w"
  ];

  vendorSha256 = "sha256-p9AYZWNO2oqLich0qzZYuAk55HqB6ttS66ORuNZ4rJg=";

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
