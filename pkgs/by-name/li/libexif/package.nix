{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "libexif";
    repo = "libexif";
    rev = "libexif-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "sha256-H51RlMT3swWF8oLWu70eTnuumee5mRMSCWkMFX7mJSk=";
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
