{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  ghostscript,
  file,
  gnused,
  gnugrep,
  coreutils,
  which,
  perl,
  libredirect,
  autoPatchelfHook,
}:
let
  version = "1.0.5-0";
  model = "mfcj995dw";
  interpreter = stdenv.cc.bintools.dynamicLinker;
in
stdenv.mkDerivation {
  pname = "cups-brother-${model}";
  inherit version;
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103811/mfcj995dwpdrv-${version}.i386.deb";
    hash = "sha256-QT/UZYMiIkdRQn0uWsHJytdQtNnEqWqICTby0FSNE74=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    runHook preInstall

    cp -r $out/usr/bin $out/bin

    mkdir -p $out/lib/cups/filter $out/share/cups/model
    ln -s $out/opt/brother/Printers/${model}/lpd/filter_${model} $out/lib/cups/filter/brlpdwrapper${model}
    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter/brother_lpdwrapper_${model}
    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/brother_${model}_printer_en.ppd

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter_${model} \
      --replace-fail /usr/bin/perl ${lib.getExe perl} \
      --replace-fail "PRINTER =~" "PRINTER = \"${model}\"; #" \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/${model}/\"; #"

    substituteInPlace $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} \
      --replace-fail /usr/bin/perl ${lib.getExe perl} \
      --replace-fail "basedir =~ " "basedir = \"$out/opt/brother/Printers/${model}/\"; #" \
      --replace-fail "PRINTER =~ " "PRINTER = \"${model}\"; #" \
      --replace-fail "LPDCONFIGEXE=" "LPDCONFIGEXE=\"$out/bin/brprintconf_\"; #"
  '';

  postFixup = ''
    wrapProgram $out/opt/brother/Printers/${model}/lpd/filter_${model} \
        --prefix PATH ":" ${
          lib.makeBinPath [
            ghostscript
            file
            gnused
            gnugrep
            coreutils
            which
          ]
        }
    wrapProgram $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gnugrep
          coreutils
        ]
      }
    wrapProgram $out/bin/brprintconf_${model} \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt
    wrapProgram $out/opt/brother/Printers/${model}/lpd/br${model}filter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt
  '';

  meta = {
    homepage = "https://www.brother.com/";
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=eu_ot&lang=en&prod=${model}_eu&os=128";
    description = "Brother MFC-J995DW printer driver";
    license = with lib.licenses; [
      unfreeRedistributable
      gpl2Only
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ poach3r ];
  };
}
