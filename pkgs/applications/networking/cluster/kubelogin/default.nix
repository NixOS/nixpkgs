{ lib, fetchFromGitHub, buildGoModule, go }:

buildGoModule rec {
  pname = "kubelogin";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0+4hrC7A60dbf+1uvTVU2JRynvA3O/lXfgcra1fV9bI=";
  };

  vendorSha256 = "sha256-erGqCpWlAQanY1ghpNVRhzUEIXv3lCiBGRs888MmHN8=";

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
