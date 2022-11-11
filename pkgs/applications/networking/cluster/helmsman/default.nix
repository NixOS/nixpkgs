{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  pname = "helmsman";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-wKemvUk5UP4LweX9JxbsYlrjuVRgchkOvlHqRYvAB9A=";
  };

  vendorSha256 = "sha256-swUZqrQ0nJS66oyqn0ONmFutLR2mEnDviC8siQB19c8=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [ lynty ];
    platforms = platforms.unix;
  };
}
