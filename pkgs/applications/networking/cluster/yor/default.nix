{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "yor";
  version = "0.1.188";

  src = fetchFromGitHub {
    owner = "bridgecrewio";
    repo = pname;
    rev = version;
    hash = "sha256-8bQUZFV5euXki7jz3tZmhJ/vSFnJusYyejfw0s+N6rk=";
  };

  vendorHash = "sha256-VYzMdYwWe2TTIV28kORX6pImSE04aFISDCjlQvqiIp8=";

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
