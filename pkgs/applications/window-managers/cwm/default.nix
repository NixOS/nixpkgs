{ lib, stdenv, fetchFromGitHub, libX11, libXinerama, libXrandr, libXft, bison, pkg-config }:

stdenv.mkDerivation rec {

  pname = "cwm";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lkjsxGMXOrnu4cUiV/TO7yzd9FzM297MhaFKauqmiHo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libX11 libXinerama libXrandr libXft bison ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = with lib; {
    description = "A lightweight and efficient window manager for X11";
    homepage    = "https://github.com/leahneukirchen/cwm";
    maintainers = with maintainers; [ _0x4A6F mkf ];
    license     = licenses.isc;
    platforms   = platforms.linux;
  };
}
