{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "starboard";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cDqZo0GTpvvkEiccP42u9X2ydHkSBuoD8Zfp+i+/qjo=";
  };

  vendorSha256 = "sha256-noK4fF9wCP1dYfDgmJVZehcF+eunzP+d9n1SiPO9UEU=";

  subPackages = [ "cmd/starboard" ];

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "Kubernetes-native security tool kit";
    longDescription = ''
      Starboard integrates security tools into the Kubernetes environment, so
      that users can find and view the risks that relate to different resources
      in a Kubernetes-native way. Starboard provides custom security resources
      definitions and a Go module to work with a range of existing security
      tools, as well as a kubectl-compatible command-line tool and an Octant
      plug-in that make security reports available through familiar Kubernetes
      tools.
    '';
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
