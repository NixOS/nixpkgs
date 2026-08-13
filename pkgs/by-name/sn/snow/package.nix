{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snow";
  version = "20130616";

  src = fetchurl {
    url = "https://web.archive.org/web/20200304125913if_/http://darkside.com.au/snow/snow-${finalAttrs.version}.tar.gz";
    sha256 = "0r9q45y55z4i0askkxmxrx0jr1620ypd870vz0hx2a6n9skimdy0";
  };

  preBuild = ''
    makeFlagsArray+=(CFLAGS="-O2 -std=c89")
  '';

  installPhase = ''
    install -Dm755 snow -t $out/bin
  '';

  meta = {
    description = "Conceal messages in ASCII text by appending whitespace to the end of lines";
    mainProgram = "snow";
    homepage = "http://www.darkside.com.au/snow/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
