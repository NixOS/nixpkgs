{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevdev";
  version = "1.13.7";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libevdev/libevdev-${finalAttrs.version}.tar.xz";
    hash = "sha256-DK+CSXEQjxW7KtNWQzuuGY19O/HoLUP2NibgaeBgv6Y=";
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
