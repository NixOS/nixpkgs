{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "f1viewer";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "SoMuchForSubtlety";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jXC2dENXuqicNQqTHyZKsjibDvjta/npQmf3+uivjX0=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-UNeH3zxgssXxFpJws6nAL8EgXt0DRyAQfmlJWz/qyDg=";
=======
  vendorSha256 = "sha256-UNeH3zxgssXxFpJws6nAL8EgXt0DRyAQfmlJWz/qyDg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description =
      "A TUI to view Formula 1 footage using VLC or another media player";
    homepage = "https://github.com/SoMuchForSubtlety/f1viewer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michzappa ];
  };
}
