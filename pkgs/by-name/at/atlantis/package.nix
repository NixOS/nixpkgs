{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "atlantis";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    rev = "v${version}";
    hash = "sha256-6/e3h4et5xzo0Eoh5I90FW9drOUSut1Wz7MgTSlVXGk=";
  };
  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-OZBvDblAQ3VZ4AOnfSOlGrcKKzAkngRanwLzU0dPe+s=";

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
