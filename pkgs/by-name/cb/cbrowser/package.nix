{
  fetchurl,
  lib,
  stdenv,
  tk,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "cbrowser";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1050mirjab23qsnq3lp3a9vwcbavmh9kznzjm7dr5vkx8b7ffcji";
  };

  patches = [ ./backslashes-quotes.diff ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tk ];

  installPhase = ''
    mkdir -p $out/bin $out/share/${pname}-${version}
    cp -R * $out/share/${pname}-${version}/

    makeWrapper $out/share/${pname}-${version}/cbrowser $out/bin/cbrowser \
      --prefix PATH : ${tk}/bin
  '';

  meta = {
    description = "Tcl/Tk GUI front-end to cscope";
    mainProgram = "cbrowser";

    license = lib.licenses.gpl2Plus;

    homepage = "https://sourceforge.net/projects/cbrowser/";

    maintainers = [ ];

    platforms = with lib.platforms; linux;
  };
}
