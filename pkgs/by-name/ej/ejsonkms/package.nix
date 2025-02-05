{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule rec {
  pname = "ejsonkms";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${version}";
    hash = "sha256-kk/+EOZ1g6SiIajcKXf6lVnll/NRWgwbFO2j07HERBI=";
  };

  vendorHash = "sha256-ZSoxG532eicpR1pS2oLYnJxtJrsHZZRbjncxU4uyT3c=";

  ldflags = [
    "-X main.version=v${version}"
    "-s"
    "-w"
  ];

  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = ejsonkms;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Integrates EJSON with AWS KMS";
    homepage = "https://github.com/envato/ejsonkms";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
