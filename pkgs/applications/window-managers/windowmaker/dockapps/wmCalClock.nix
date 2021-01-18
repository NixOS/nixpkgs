{ lib, stdenv, dockapps-sources
, libX11, libXpm, libXext }:

stdenv.mkDerivation rec {
  pname = "wmCalClock";
  version = "1.25";

  src = dockapps-sources;

  buildInputs = [ libX11 libXpm libXext ];

  setSourceRoot = ''
    export sourceRoot=$(echo */${pname}/Src)
  '';

  preBuild = ''
    makeFlagsArray+=(
      CC="cc"
      INCDIR="-I${libX11.dev}/include -I${libXext.dev}/include -I${libXpm.dev}/include"
      LIBDIR="-I${libX11}/lib -I${libXext}/lib -I${libXpm}/lib"
    )
  '';

  preInstall = ''
    install -d ${placeholder "out"}/bin
    install -d ${placeholder "out"}/man/man1
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = with lib; {
    description = "A Calendar clock with antialiased text";
    homepage = "https://www.dockapps.net/wmcalclock";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bstrik ];
    platforms = platforms.linux;
  };
}
