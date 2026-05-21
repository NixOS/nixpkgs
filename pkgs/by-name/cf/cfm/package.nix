{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cfm";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "willeccles";
    repo = "cfm";
    rev = "v${finalAttrs.version}";
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
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "cfm";
  };
})
