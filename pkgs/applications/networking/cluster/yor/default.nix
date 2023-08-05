{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "yor";
  version = "0.1.183";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = version;
    hash = "sha256-OMwDqBZPzjeG47CKk/heRo0JxyN7E7qh/dnV8cAzUfo=";
  };

  vendorHash = "sha256-ZeTjGmlu8LndD2DKNncPzlpECdvkOjfwaVvV6S3sL9E=";

  doCheck = false;

  # https://github.com/bridgecrewio/yor/blob/main/set-version.sh
  preBuild = ''
    cat << EOF > src/common/version.go
    package common

    const Version = "${version}"
    EOF
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Extensible auto-tagger for your IaC files. The ultimate way to link entities in the cloud back to the codified resource which created it.";
    homepage = "https://github.com/bridgecrewio/yor";
    changelog = "https://github.com/bridgecrewio/yor/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
