{ stdenv
, a2ps
, lib
, fetchdeb
, dpkg
, makeWrapper
, coreutils
, file
, gawk
, ghostscript
, gnused
, pkgsi686Linux
}:

stdenv.mkDerivation rec {
  pname = "mfc5890cnlpr";
  version = "1.1.2-2";

  src = fetchdeb {
    url = "https://download.brother.com/welcome/dlf006168/${pname}-${version}.i386.deb";
    hash = "sha256-8vm1rLqTzcsVVg9JvtQ5T8SiRV9LAccWDGIn0s9QhsE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r . $out/.

    dir=$out/usr/local/Brother/Printer/mfc5890cn

    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $dir/lpd/brmfc5890cnfilter

    wrapProgram $dir/inf/setupPrintcapij \
      --prefix PATH : ${lib.makeBinPath [
        coreutils
      ]}

    substituteInPlace $dir/lpd/filtermfc5890cn \
      --replace "/usr/" "$out/usr/"

    wrapProgram $dir/lpd/filtermfc5890cn \
      --prefix PATH : ${lib.makeBinPath [
        a2ps
        coreutils
        file
        ghostscript
        gnused
      ]}

    substituteInPlace $dir/lpd/psconvertij2 \
      --replace '`which gs`' "${ghostscript}/bin/gs"

    wrapProgram $dir/lpd/psconvertij2 \
      --prefix PATH : ${lib.makeBinPath [
        gnused
        gawk
      ]}
  '';

  meta = with lib; {
    description = "Brother MFC-5890CN LPR printer driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ martinramm ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
