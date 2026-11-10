{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevdev";
  version = "1.13.6";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/libevdev-${finalAttrs.version}.tar.xz";
    hash = "sha256-c/IV7MvYIz9BRzesBryiaH5nxEuX0tdXYJGqlxhVERA=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  meta = {
    description = "Wrapper library for evdev devices";
    homepage = "https://www.freedesktop.org/software/libevdev/doc/latest/index.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
