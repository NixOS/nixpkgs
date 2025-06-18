{
  stdenv,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "libident";
  version = "0.22";
  src = fetchzip {
    url = "https://ftp.lysator.liu.se/pub/ident/libs/${pname}-${version}.tar.gz";
    hash = "sha256-kMh5Ch8r6k76wFLwhfICaFySIjdKG2751rZLmQ0pkoE=";
  };
  buildFlags = [ "linux" ];
  makeFlags = [
    "INSTROOT=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
    "INCDIR=${placeholder "out"}/include"
    "MANDIR=${placeholder "out"}/man"
  ];
  preInstall = ''
    mkdir -p $out/lib $out/include $out/man
  '';
  meta = with lib; {
    homepage = "https://www.lysator.liu.se/~pen/pidentd/";
    description = "simple RFC1413 client library";
    maintainers = with maintainers; [
      ezrizhu
    ];
    license = with licenses; [ publicDomain ];
    platforms = platforms.linux;
  };
}
