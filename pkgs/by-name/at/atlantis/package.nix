{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "atlantis";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    hash = "sha256-2xgU3H6X9EcbySV9RXN5oCn+7EkfdwebeYsL5+Vl69E=";
  };
  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-1xII3GIQQCku3UzwPJnJu//zAJGuGCOSETR6sU4lPR8=";

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
