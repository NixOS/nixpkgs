{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.16.4";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-8hv68O4U9bPjqqtVOpmY3DwfeTGEZJGVkzIyYhS14aM=";
  };

  vendorHash = "sha256-aSpv4TGp0YLdk/RYEvfYswlEWnv8sy9iflXGGCcKPHs=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
