{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "writefreely";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "writeas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6LpRfDu3xvE1eIRLfZliKnzsrrG5pjjf2ydxn9HQJJU=";
  };

  vendorSha256 = "sha256-U17AkMJQr/OIMED0i2ThcNVw3+aOvRLbpLNP/wEv6k8=";

  nativeBuildInputs = [ go-bindata ];

  preBuild = ''
    make assets
  '';

  ldflags = [ "-s" "-w" "-X github.com/writeas/writefreely.softwareVer=${version}" ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writeas/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
