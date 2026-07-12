{
  stdenv,
  stdenvNoCC,
  lib,
  fetchurl,
  perl,
  gnused,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  libredirect,
  gnugrep,
  coreutils,
  ghostscript,
  file,
  pkgsi686Linux,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cups-brother-dcpt310";
  version = "1.0.1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103618/dcpt310pdrv-${finalAttrs.version}-0.i386.deb";
    sha256 = "0g9hylmpgmzd6k9lxjy32c7pxbzj6gr9sfaahxj3xzqyar05amdx";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    perl
    gnused
    libredirect
    pkgsi686Linux.stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -pr opt "$out"
    cp -pr usr/bin "$out/bin"
    rm "$out/opt/brother/Printers/dcpt310/cupswrapper/cupswrapperdcpt310"

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s "../../../opt/brother/Printers/dcpt310/cupswrapper/brother_lpdwrapper_dcpt310" \
      "$out/lib/cups/filter/brother_lpdwrapper_dcpt310"
    ln -s "../../../opt/brother/Printers/dcpt310/cupswrapper/brother_dcpt310_printer_en.ppd" \
      "$out/share/cups/model/brother_dcpt310_printer_en.ppd"

    runHook postInstall
  '';

  # Fix global references and replace auto discovery mechanism
  # with hardcoded values.
  #
  # The configuration binary 'brprintconf_dcpt310' and lpd filter
  # 'brdcpt310filter' has hardcoded /opt format strings.  There isn't
  # sufficient space in the binaries to substitute a path in the store, so use
  # libredirect to get it to see the correct path.  The configuration binary
  # also uses this format string to print configuration locations.  Here the
  # wrapper output is processed to point into the correct location in the
  # store.

  postFixup = ''
    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2

    substituteInPlace $out/opt/brother/Printers/dcpt310/lpd/filter_dcpt310 \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/dcpt310/\"; #" \
      --replace /usr/bin/pdf2ps "${ghostscript}/bin/pdf2ps" \
      --replace "my \$GHOST_SCRIPT" "my \$GHOST_SCRIPT = \"${ghostscript}/bin/gs\"; #" \
      --replace "PRINTER =~" "PRINTER = \"dcpt310\"; #"

    substituteInPlace $out/opt/brother/Printers/dcpt310/cupswrapper/brother_lpdwrapper_dcpt310 \
      --replace "PRINTER =~" "PRINTER = \"dcpt310\"; #" \
      --replace "my \$basedir = \`readlink \$0\`" "my \$basedir = \"$out/opt/brother/Printers/dcpt310/\"" \
      --replace "my \$lpdconf = \$LPDCONFIGEXE.\$PRINTER;" "my \$lpdconf = \"$out/bin/brprintconf_dcpt310\";"


    patchelf --set-interpreter "$interpreter" "$out/opt/brother/Printers/dcpt310/lpd/brdcpt310filter" \
      --set-rpath ${lib.makeLibraryPath [ pkgsi686Linux.stdenv.cc.cc ]}
    patchelf --set-interpreter "$interpreter" "$out/bin/brprintconf_dcpt310"


    wrapProgram $out/bin/brprintconf_dcpt310 \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $out/opt/brother/Printers/dcpt310/lpd/brdcpt310filter \
      --set PATH ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          ghostscript
        ]
      } \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    for f in \
      $out/opt/brother/Printers/dcpt310/cupswrapper/brother_lpdwrapper_dcpt310 \
      $out/opt/brother/Printers/dcpt310/lpd/filter_dcpt310 \
    ; do
      wrapProgram $f \
        --set PATH ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
            file
          ]
        }
    done

    substituteInPlace $out/bin/brprintconf_dcpt310 \
      --replace \"\$"@"\" \"\$"@\" | LD_PRELOAD= ${gnused}/bin/sed -E '/^(function list :|resource file :).*/{s#/opt#$out/opt#}'"
  '';

  meta = {
    description = "Brother DCP-T310 printer driver";
    license = with lib.licenses; [
      unfree
      gpl2Plus
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
    maintainers = with lib.maintainers; [ inexcode ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    homepage = "https://www.brother.com/";
    downloadPage = "https://support.brother.com/g/b/downloadhowto.aspx?c=us_ot&lang=en&prod=dcpt310_all&os=128&dlid=dlf103618_000&flang=4&type3=10283";
  };
})
