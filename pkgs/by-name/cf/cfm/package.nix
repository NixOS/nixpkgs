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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uXL0RO9P+NYSZ0xCv91KzjHOJJI500YUT8IJkFS86pE=";
  };

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = {
    homepage = "https://github.com/willeccles/cfm";
    description = "Simple and fast TUI file manager with no dependencies";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ lom ];
    platforms = lib.platforms.all;
    mainProgram = "cfm";
  };
}
