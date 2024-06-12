{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-APRa+wZhls7O2q3zVPEB9Kegd1YspcfC8PSJy6KFlR8=";
  };

  vendorHash = "sha256-OLsJc/AMtD03KA8SN5rsnaq57/cB7bMB/f7FfEjErEU=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "Third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "hydroxide";
  };
}
