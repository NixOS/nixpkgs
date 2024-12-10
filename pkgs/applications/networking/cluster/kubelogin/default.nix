{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go,
}:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5Y+xu84iNVFkrBc1qoTg8vMswvlflF9SobMy/Aw4mCA=";
  };

  vendorHash = "sha256-sVySHSj8vJEarQlhAR3vLdgysJNbmA2IAZ3ET2zRyAM=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    mainProgram = "kubelogin";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [ ];
  };
}
