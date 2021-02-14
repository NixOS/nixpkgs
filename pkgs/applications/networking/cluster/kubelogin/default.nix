{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iR+DomoCErzl9GEE8qTWEkJvbCnw4Ob7R66eluMBNcQ=";
  };

  vendorSha256 = "sha256-HXSvZoOX22poOYGghCpXX9BSSR9L6YMqw+7x4WZS39o=";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
        -X main.goVersion=${lib.getVersion go}
  '';

  meta = with lib; {
    description = "A Kubernetes credential plugin implementing Azure authentication";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
  };
}
