{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zarf";
<<<<<<< HEAD
  version = "0.29.1";
=======
  version = "0.26.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "defenseunicorns";
    repo = "zarf";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-m/eyy3MpHHlxlWU9Y7tsQw5jGGZIKCvBkIgoRmvecBI=";
  };

  vendorHash = "sha256-p1QLNbkNlIwqHzLjGX5YGC2Xxu0nAjmMfGwKXhi9XkU=";
=======
    hash = "sha256-gJpXdT0Uj+7UecPPuRphbtbh8v80UztKmiOAP+U7Tpc=";
  };

  vendorHash = "sha256-5k2NnQ18bL0v7YHTvw2nz5H5n5DQOmozkUhyf97eKl8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
