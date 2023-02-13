{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bstrg/TtGpC4zeJEYgycwdzBMfMbQX0S6okdtUiVMIQ=";
  };

  vendorSha256 = "sha256-OLsJc/AMtD03KA8SN5rsnaq57/cB7bMB/f7FfEjErEU=";

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
