{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gosimports";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "rinchsan";
    repo = "gosimports";
    rev = "v${version}";
    hash = "sha256-xM1CGW8UB+VHN+2Rm6cF/1bOBVDeUG+6kxUxUcvP7FM=";
  };

  vendorHash = "sha256-xR1YTwUcJcpe4NXH8sp9bNAWggvcvVJLztD49gQIdMU=";

  subPackages = [ "cmd/gosimports" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/rinchsan/gosimports";
    description = "Simpler goimports";
    license = licenses.bsd3;
    maintainers = with maintainers; [ maolonglong ];
    mainProgram = "gosimports";
  };
}
