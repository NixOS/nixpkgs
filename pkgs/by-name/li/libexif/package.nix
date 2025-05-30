{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.25";

  src = fetchFromGitHub {
    owner = "libexif";
    repo = "libexif";
    rev = "libexif-${builtins.replaceStrings [ "." ] [ "_" ] version}-release";
    sha256 = "sha256-H8YzfNO2FCrYAwEA4bkOpRdxISK9RXaHVuK8zz70TlM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
  ];

  meta = with lib; {
    homepage = "https://libexif.github.io/";
    description = "Library to read and manipulate EXIF data in digital photographs";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ ];
  };

}
