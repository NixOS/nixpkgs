{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctpl";
  version = "0.3.5";

  src = fetchurl {
    url = "https://download.tuxfamily.org/ctpl/releases/ctpl-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-IRCPx1Z+0hbe6kWRrb/s6OiLH0uxynfDdACSBkTXVr4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ];

  meta = {
    homepage = "http://ctpl.tuxfamily.org/";
    description = "Template engine library written in C";
    mainProgram = "ctpl";
    platforms = lib.platforms.linux;
    maintainers = [ ];
    license = lib.licenses.gpl3Plus;
  };
})
