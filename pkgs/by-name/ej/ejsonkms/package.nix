{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ejsonkms,
}:

buildGoModule rec {
  pname = "ejsonkms";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${version}";
    hash = "sha256-EcNvzkZmSASe+0UMixBe8qwZq1JN3zFvppdWu1LM46A=";
  };

  vendorHash = "sha256-LS+iCTpE7+vXa25CTudNHLPRYSod4ozuErnoYWB9LNU=";

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
