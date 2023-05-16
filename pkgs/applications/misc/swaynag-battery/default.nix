{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "swaynag-battery";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "m00qek";
    repo = "swaynag-battery";
    rev = "v${version}";
    hash = "sha256-7f9+4Fzw5B5ATuud4MJC3iyuNRTx6kwJ7/KsusGtQM8=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-h9Zj3zmQ0Xpili5Pl6CXh1L0bb2uL1//B79I4/ron08=";
=======
  vendorSha256 = "h9Zj3zmQ0Xpili5Pl6CXh1L0bb2uL1//B79I4/ron08=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/m00qek/swaynag-battery";
    description = "Shows a message when your battery is discharging ";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
