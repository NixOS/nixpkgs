{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.13.3";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-q/GqzoYgjuvdXTVQ/97UyNc7tAW3ltUcOJydBgTLz78=";
  };

  nativeBuildInputs = [ python3 ];

  meta = {
    description = "Wrapper library for evdev devices";
    homepage = "https://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.amorsillo ];
  };
}
