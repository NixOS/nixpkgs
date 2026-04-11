{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  which,
  pkg-config,
  mono,
  gtk-sharp-2_0,
  gio-sharp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-sharp-beans";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gtk-sharp-beans";

    rev = finalAttrs.version;
    sha256 = "04sylwdllb6gazzs2m4jjfn14mil9l3cny2q0xf0zkhczzih6ah1";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    which
  ];
  buildInputs = [
    mono
    gtk-sharp-2_0
    gio-sharp
  ];

  dontStrip = true;

  meta = {
    description = "Binds some API from GTK that isn't in GTK# 2.12.x";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
  };
})
