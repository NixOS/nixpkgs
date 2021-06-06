{ lib, stdenv, dockapps-sources, autoreconfHook, pkg-config
, libX11, libXext, libXpm, mkfontdir, fontutil }:

stdenv.mkDerivation rec {
  pname = "libdockapp";
  version = "0.7.3";

  src = dockapps-sources;

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libX11 libXext libXpm fontutil mkfontdir ];

  setSourceRoot = ''
    export sourceRoot=$(echo */${pname})
  '';

  # There is a bug on --with-font
  configureFlags = [
    "--with-examples=no"
    "--with-font=no"
  ];

  meta = with lib; {
    description = "A library providing a framework for dockapps";
    homepage = "https://www.dockapps.net/libdockapp";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bstrik ];
  };
}
