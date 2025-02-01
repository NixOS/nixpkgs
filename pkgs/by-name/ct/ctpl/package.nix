{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "ctpl";
  version = "0.3.5";

  src = fetchurl {
    url = "https://download.tuxfamily.org/ctpl/releases/ctpl-${version}.tar.gz";
    sha256 = "sha256-IRCPx1Z+0hbe6kWRrb/s6OiLH0uxynfDdACSBkTXVr4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ];

  meta = with lib; {
    homepage = "http://ctpl.tuxfamily.org/";
    description = "Template engine library written in C";
    mainProgram = "ctpl";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl3Plus;
  };
}
