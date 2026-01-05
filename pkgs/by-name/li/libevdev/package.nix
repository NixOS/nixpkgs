{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libevdev";
  version = "1.13.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-8Aq41CrYuQUpb6tn4TuHHxpCSDkzFRZkIQD4KtiBJ80=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  meta = with lib; {
    description = "Wrapper library for evdev devices";
    homepage = "https://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
