{ stdenv, fetchFromGitHub, cmake, pkgconfig, gtk3, ncurses, curl
, json_c, libcpuid, pciutils, procps, wrapGAppsHook, nasm }:

stdenv.mkDerivation rec {
  pname = "cpu-x";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "v${version}";
    sha256 = "03y49wh9v7x6brmavj5a2clihn0z4f01pypl7m8ymarv4y3a6xkl";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook nasm ];
  buildInputs = [
    gtk3 ncurses curl json_c libcpuid pciutils procps
  ];

  meta = with stdenv.lib; {
    description = "Free software that gathers information on CPU, motherboard and more";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ gnidorah ];
  };
}
