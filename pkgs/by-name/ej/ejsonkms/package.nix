{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule rec {
  pname = "ejsonkms";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${version}";
    hash = "sha256-qsPn9opDyahyYSOXO9GB2RSHNZupXlAUIxPJRyVgqQo=";
  };

  vendorHash = "sha256-DovbNZBdJxLpdggaxbe90pqHjl4fp4D7IZT9Z/j3yLI=";

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
