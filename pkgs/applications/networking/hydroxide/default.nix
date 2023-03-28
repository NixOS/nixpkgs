{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.25";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YBaimsHRmmh5d98c9x56JIyOOnkZsypxdqlSCG6pVJ4=";
  };

  vendorHash = "sha256-OLsJc/AMtD03KA8SN5rsnaq57/cB7bMB/f7FfEjErEU=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "A third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = platforms.unix;
  };
}
