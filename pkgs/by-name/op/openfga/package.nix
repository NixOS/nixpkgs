{ lib, buildGoModule, fetchFromGitHub, go }:

buildGoModule rec {
  pname = "openfga";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "openfga";
    repo = "openfga";
    rev = "v${version}";
    sha256 = "sha256-lqAoIOnizfvZm/NjGeinXzoci+ykmzdFtLDGeNoi97c=";
  };

  vendorHash = "sha256-vUfyo7/mapAzNs6RV+GVj5gOPEpMypNNIkoUgnBYTjA=";
  subPackages = [ "./cmd/openfga" ];

  ldflags = [ "-s" "-w" "-X github.com/openfga/openfga/internal/build.Version=${version}" ];
  meta = with lib; {
    description = "A high performance and flexible authorization/permission engine built for developers and inspired by Google Zanzibar";
    homepage = "https://openfga.dev/";
    license = licenses.asl20;
    mainProgram = "openfga";
    maintainers = with maintainers; [ mjarosie ];
  };

}
