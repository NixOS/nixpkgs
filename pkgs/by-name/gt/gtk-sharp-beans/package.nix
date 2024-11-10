{ lib, stdenv, fetchFromGitHub, autoreconfHook, which, pkg-config, mono, gtk-sharp-2_0, gio-sharp }:

stdenv.mkDerivation rec {
  pname = "gtk-sharp-beans";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "gtk-sharp-beans";

    rev = version;
    sha256 = "04sylwdllb6gazzs2m4jjfn14mil9l3cny2q0xf0zkhczzih6ah1";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook which ];
  buildInputs = [ mono gtk-sharp-2_0 gio-sharp ];

  dontStrip = true;

  meta = with lib; {
    description = "Binds some API from GTK that isn't in GTK# 2.12.x";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
