{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  pname = "dlx";
  version = "0-unstable-2012-07-08";

  src = fetchzip {
    url = "https://www.davidviner.com/zip/dlx/dlx.zip";
    hash = "sha256-r4FlMbfsGH50V502EfqzRwAqVv4vpdyH3zFlZW2kCBQ=";
  };

  preBuild = ''
    makeFlagsArray+=(
      CC="${stdenv.cc.targetPrefix}cc"
      LINK="${stdenv.cc.targetPrefix}cc"
      CFLAGS="-O2 -Wno-implicit-function-declaration"
    )
  '';

  hardeningDisable = [ "format" ];

  installPhase = ''
    mkdir -p $out/include/dlx $out/share/dlx/{examples,doc} $out/bin
    mv masm mon dasm $out/bin/
    mv *.i auto.a $out/include/dlx/
    mv *.a *.m $out/share/dlx/examples/
    mv README.txt MANUAL.TXT $out/share/dlx/doc/
  '';

  meta = {
    homepage = "https://www.davidviner.com/dlx.html?name=DLX+Simulator";
    description = "DLX simulator written in C";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
