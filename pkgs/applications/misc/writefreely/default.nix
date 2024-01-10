{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "writefreely";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vOoTAr33FMQaHIwpwIX0g/KJWQvDn3oVJg14kEY6FIQ=";
  };

  vendorHash = "sha256-xTo/zbz9pSjvNntr5dnytiJ7oRAdtEuyiu4mJZgwHTc=";

  ldflags = [ "-s" "-w" "-X github.com/writefreely/writefreely.softwareVer=${version}" ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ soopyc ];
  };
}
