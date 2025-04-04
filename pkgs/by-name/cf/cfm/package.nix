{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cfm";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "willeccles";
    repo = "cfm";
    rev = "v${version}";
    sha256 = "sha256-uXL0RO9P+NYSZ0xCv91KzjHOJJI500YUT8IJkFS86pE=";
  };

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    homepage = "https://github.com/willeccles/cfm";
    description = "Simple and fast TUI file manager with no dependencies";
    license = licenses.mpl20;
    maintainers = with maintainers; [ lom ];
    platforms = platforms.all;
    mainProgram = "cfm";
  };
}
