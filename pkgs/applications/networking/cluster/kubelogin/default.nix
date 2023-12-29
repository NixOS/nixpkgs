{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bPxsXRXk8hlhIhj2tO7mJ5XYd6oNH25cwp5CUVo65mo=";
  };

  vendorHash = "sha256-WZTtu7T7aWOk3Q0HBjGcc+lsgOExmQQEs0lEEvP+Wb4=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = [];
  };
}
