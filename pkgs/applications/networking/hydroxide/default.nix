{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.17";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gNMLVh5ntVCxiIKLshRvYXi5dYLZ8qiZFwZxbNPVFTk=";
  };

  vendorSha256 = "sha256-f/1Vxuc87eQie/j1b14q/1lAAzRk+ZDkBaTmHtCy7go=";

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
