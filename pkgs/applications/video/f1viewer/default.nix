{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "f1viewer";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "SoMuchForSubtlety";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MY8xqpAzK1c4XL7w/LR83DyHFCI5X7wldosDDo7pXNI=";
  };

  vendorSha256 = "sha256-8c1+t6Lo11Q2kEDy9IWLw9bsZYtJFksE7Om3ysx7fc4=";

  meta = with lib; {
    description =
      "A TUI to view Formula 1 footage using VLC or another media player";
    homepage = "https://github.com/SoMuchForSubtlety/f1viewer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michzappa ];
  };
}
