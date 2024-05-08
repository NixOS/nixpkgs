{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "atlantis";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    hash = "sha256-BC4WSyKnDM9RhM+2iU9dBZLbtxDM/UoMmIDTP6DB3no=";
  };
  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-6Di8XLX1rOjVnIA+5kQB59aZ3qRmkjciWD0+GD9Lpzw=";

  subPackages = [ "." ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/atlantis version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpotier ];
  };
}
