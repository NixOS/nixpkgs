{
  pkgsi686Linux,
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
}:
let
  version = "1.0.5-0";
  model = "mfcj995dw";
  interpreter = "${pkgsi686Linux.stdenv.cc.libc}/lib/ld-linux.so.2";
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
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src $out

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter_${model} \
      --replace-fail /usr/bin/perl ${lib.getExe perl} \
      --replace-fail "PRINTER =~" "PRINTER = \"${model}\"; #" \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/${model}/\"; #"

    substituteInPlace $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} \
      --replace-fail /usr/bin/perl ${lib.getExe perl} \
      --replace-fail "basedir =~ " "basedir = \"$out/opt/brother/Printers/${model}/\"; #" \
      --replace-fail "PRINTER =~ " "PRINTER = \"${model}\"; #" \
      --replace-fail "LPDCONFIGEXE=" "LPDCONFIGEXE=\"$out/usr/bin/brprintconf_\"; #"

    patchelf --set-interpreter ${interpreter} $out/opt/brother/Printers/${model}/lpd/br${model}filter
    patchelf --set-interpreter ${interpreter} $out/usr/bin/brprintconf_${model}

    mkdir -p $out/lib/cups/filter $out/share/cups/model
    ln -s $out/opt/brother/Printers/${model}/lpd/filter_${model} $out/lib/cups/filter/brlpdwrapper${model}
    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter/brother_lpdwrapper_${model}
    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/brother_${model}_printer_en.ppd

    runHook postInstall
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
    wrapProgram $out/usr/bin/brprintconf_${model} \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt
    wrapProgram $out/opt/brother/Printers/${model}/lpd/br${model}filter \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
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
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ poach3r ];
  };
}
