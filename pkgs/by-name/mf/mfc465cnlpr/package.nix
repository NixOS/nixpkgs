{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  file,
  gawk,
  ghostscript,
  gnused,
  pkgsi686Linux,
}:

stdenv.mkDerivation rec {
  pname = "mfc465cnlpr";
  version = "1.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006132/${pname}-${version}.i386.deb";
    sha256 = "cfe0289510bf36bee6014286ea78b1ebc6bbb948dbfd3aee02f0664a7743f99b";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    dir=$out/usr/local/Brother/Printer/mfc465cn
    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $dir/lpd/brmfc465cnfilter
    wrapProgram $dir/inf/setupPrintcapij \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
        ]
      }
    substituteInPlace $dir/lpd/filtermfc465cn \
      --replace "BR_PRT_PATH=" "BR_PRT_PATH=\"$dir/\" #"
    wrapProgram $dir/lpd/filtermfc465cn \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          file
          ghostscript
          gnused
        ]
      }
    substituteInPlace $dir/lpd/psconvertij2 \
      --replace '`which gs`' "${ghostscript}/bin/gs"
    wrapProgram $dir/lpd/psconvertij2 \
      --prefix PATH : ${
        lib.makeBinPath [
          gnused
          gawk
        ]
      }
    chmod -R a+w $dir/inf/
  '';

  meta = with lib; {
    description = "Brother MFC-465CN LPR printer driver";
    homepage = "http://www.brother.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ phrogg ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
