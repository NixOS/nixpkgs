{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pachyderm";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "pachyderm";
    repo = "pachyderm";
    rev = "v${version}";
    hash = "sha256-/9j7umcIffG5jAaUW/jmIX5CUD9dUq5/ZKhzbKx0Kw4=";
  };

  vendorHash = "sha256-6iwiepmzxZ4cGsPeHQDNFd2VuhmjTAX9kBdjaQPBMKU=";

  subPackages = [ "src/server/cmd/pachctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pachyderm/pachyderm/v${lib.versions.major version}/src/version.AppVersion=${version}"
  ];

  meta = with lib; {
    description = "Containerized Data Analytics";
    homepage = "https://www.pachyderm.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    mainProgram = "pachctl";
  };
}
