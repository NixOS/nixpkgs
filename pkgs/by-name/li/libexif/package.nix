{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.24";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "sha256-Eqgnm31s8iPJdhTpk5HM89HSZTXTK+e7YZ/CCdbeJX4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
  ];

  meta = {
    homepage = "https://libexif.github.io/";
    description = "Library to read and manipulate EXIF data in digital photographs";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };

}
