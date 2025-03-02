{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkgsi686Linux,
  ghostscript,
  file,
  a2ps,
  which,
}:

let
  version = "1.1.2";
  model = "dcp385c";
in
stdenv.mkDerivation {
  pname = "${model}-lpr";
  inherit version;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf005395/${model}lpr-${version}-2.i386.deb";
    hash = "sha256-Y2lBU42fYXLG9D2qeUeG/sTpIIU8iHxyPALJUeZvHEk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ar x $src
    tar xvzf data.tar.gz
    sourceRoot=usr
  '';

  patchPhase = ''
    substituteInPlace local/Brother/Printer/dcp385c/lpd/filterdcp385c \
      --replace-fail /usr $out \
      --replace-fail '$BR_PRT_PATH/inf/brPRINTERrc' '/var/cache/cups/brPRINTERrc'
  '';

  installPhase = ''
    cp -r . $out
  '';

  fixupPhase = ''
    wrapProgram $out/local/Brother/Printer/dcp385c/lpd/filterdcp385c \
      --prefix PATH ":" ${
        lib.makeBinPath [
          file
          a2ps
        ]
      }

    wrapProgram $out/local/Brother/Printer/dcp385c/lpd/psconvertij2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          which
          ghostscript
        ]
      }

    interpreter="${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2"

    patchelf --set-interpreter $interpreter \
      $out/bin/brprintconf_dcp385c

    patchelf --set-interpreter $interpreter \
      $out/local/Brother/Printer/dcp385c/lpd/brdcp385cfilter
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother ${model} printer driver";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.brotherEula;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_all&os=128";
  };
}
