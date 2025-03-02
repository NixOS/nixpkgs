{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
  gnused,
  gnugrep,
  coreutils,
  dcp385c-lpr,
  dcp385c-brprintconf,
}:
let
  version = "1.1.2";
  model = "dcp385c";
  installscript = "SCRIPT/cupswrapperdcp385c";
in
stdenv.mkDerivation {
  pname = "${model}-cupswrapper";
  inherit version;

  src = fetchzip {
    url = "https://download.brother.com/welcome/dlf006678/brcups_ink4_src_1.1.2-x.tar.gz";
    hash = "sha256-2XzBF3weIlZ2g2IXFv2PE8jVXkhybrMni6jtNjkmF7I=";
  };

  nativeBuildInputs = [ makeWrapper ];
  unpackPhase = ''
    tar xzf $src/cupswrapperdcp385c_src-1.1.2-2.tar.gz
    sourceRoot=cupswrapperdcp385c_src
  '';

  patchPhase = ''
    patch ${installscript} ${./replace-absolute-paths.patch}
    substituteInPlace ${installscript} \
      --subst-var out \
      --subst-var-by lpr ${dcp385c-lpr} \
  '';

  buildPhase = ''
    $CC brcupsconfigpt1/brcupsconfig.c -o brcupsconfig
  '';

  installPhase = ''
    install -D brcupsconfig $out/local/Brother/Printer/dcp385c/cupswrapper/brcupsconfpt1

    mkdir -p $out/share/cups/model
    mkdir -p $out/lib/cups/filter
    sh ${installscript}
  '';

  fixupPhase = ''
    wrapProgram $out/lib/cups/filter/brlpdwrapperdcp385c \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gnused
          gnugrep
          coreutils
          dcp385c-brprintconf
        ]
      }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother ${model} printer CUPS wrapper driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_all&os=128";
  };
}
