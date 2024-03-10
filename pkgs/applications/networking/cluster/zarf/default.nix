{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zarf";
  version = "0.32.4";

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
    hash = "sha256-Pm8xvJKKIa7PX6oYR1LoxmHeG3rQdsfS444kL5R3/zQ=";
  };

  vendorHash = "sha256-2cXkGgyZoCsVYLPB4sglOWZURl1AS0Gb/7ke7P3mdyw=";
  proxyVendor = true;

  preBuild = ''
    mkdir -p build/ui
    touch build/ui/index.html
  '';

  doCheck = false;

  ldflags = [ "-s" "-w" "-X" "github.com/defenseunicorns/zarf/src/config.CLIVersion=${src.rev}" "-X" "k8s.io/component-base/version.gitVersion=v0.0.0+zarf${src.rev}" "-X" "k8s.io/component-base/version.gitCommit=${src.rev}" "-X" "k8s.io/component-base/version.buildDate=1970-01-01T00:00:00Z" ];

  meta = with lib; {
    description = "DevSecOps for Air Gap & Limited-Connection Systems. https://zarf.dev";
    homepage = "https://github.com/defenseunicorns/zarf.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ ragingpastry ];
  };
}
