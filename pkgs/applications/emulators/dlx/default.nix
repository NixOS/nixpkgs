{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "dlx";
  version = "2012-07-08";

  src = fetchzip {
    url = "https://www.davidviner.com/zip/dlx/dlx.zip";
    sha256 = "0508linnar9ivy3xr99gzrb2l027ngx12dlxaxs7w67cnwqnb0dg";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "LINK=${stdenv.cc.targetPrefix}cc" "CFLAGS=-O2" ];
  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/include/dlx $out/share/dlx/{examples,doc} $out/bin
    mv masm mon dasm $out/bin/
    mv *.i auto.a $out/include/dlx/
    mv *.a *.m $out/share/dlx/examples/
    mv README.txt MANUAL.TXT $out/share/dlx/doc/
  '';

  meta = with lib; {
    homepage = "https://www.davidviner.com/dlx.html?name=DLX+Simulator";
    description = "DLX simulator written in C";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
