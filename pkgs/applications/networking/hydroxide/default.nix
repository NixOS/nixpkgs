{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
<<<<<<< HEAD
  version = "0.2.27";
=======
  version = "0.2.26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-APRa+wZhls7O2q3zVPEB9Kegd1YspcfC8PSJy6KFlR8=";
=======
    sha256 = "sha256-UCS49P83dGTD/Wx95Mslstm2C6hKgJB/1tJTZmmwLDg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-OLsJc/AMtD03KA8SN5rsnaq57/cB7bMB/f7FfEjErEU=";

  doCheck = false;

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "A third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
