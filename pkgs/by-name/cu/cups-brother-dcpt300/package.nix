{
  stdenv,
  lib,
  fetchurl,
  gnumake,
  gnused,
  ghostscript,
  cups,
  dpkg,
  patchelf,
  file,
  pkgsi686Linux,
  makeWrapper,
  coreutils,
  gnugrep,
  perl,
  gawk,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-brother-dcpt300";
  version = "3.0.2-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101964/dcpt300_cupswrapper_GPL_source_${finalAttrs.version}.tar.gz";
    sha256 = "sha256-wfCTHnmkN2Ft+pI41zh6ncaG2JpaFO7IYD//88WyNPo=";
  };

  # LPR filter binary blob
  srcLpr = fetchurl {
    url = "https://download.brother.com/welcome/dlf101960/dcpt300lpr-${finalAttrs.version}.i386.deb";
    sha256 = "sha256-+0YjEwkCjAN9hSMYZ3wZ+j/5GyNpAUvmhpG+kQL2V1A=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gnumake
    dpkg
    patchelf
    file
    makeWrapper
  ];

  buildInputs = [
    cups
  ];

  postUnpack = ''
    # Extract the proprietary Debian package alongside the source
    dpkg-deb -x ${finalAttrs.srcLpr} lpr-extracted
  '';

  postPatch = ''
    cd cupswrapper

    sed -n '/cat <<!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' cupswrapperdcpt300 \
      | grep -v '!ENDOFWFILTER!' > brother_lpdwrapper_dcpt300
    sed -i 's/\\\$/$/g' brother_lpdwrapper_dcpt300
    sed -i 's/\\`/\`/g' brother_lpdwrapper_dcpt300
    sed -i 's/\\"/"/g' brother_lpdwrapper_dcpt300
    sed -i 's/''${printer_model}/dcpt300/g; s/$printer_model/dcpt300/g' brother_lpdwrapper_dcpt300
    sed -i 's/''${printer_name}/DCPT300/g; s/$printer_name/DCPT300/g' brother_lpdwrapper_dcpt300
    sed -i 's/''${device_model}/Printers/g; s/$device_model/Printers/g' brother_lpdwrapper_dcpt300
    sed -i 's/''${device_name}/DCP-T300/g; s/$device_name/DCP-T300/g' brother_lpdwrapper_dcpt300
    cd ..
    substituteInPlace ../lpr-extracted/opt/brother/Printers/dcpt300/lpd/filterdcpt300 \
      --replace "/opt/brother" "$out/opt/brother"
    substituteInPlace cupswrapper/brother_lpdwrapper_dcpt300 \
      --replace "/opt/brother" "$out/opt/brother" \
      --replace "psnup" "${ghostscript}/bin/psnup"
    substituteInPlace ../lpr-extracted/opt/brother/Printers/dcpt300/lpd/psconvertij2 \
      --replace "/opt/brother" "$out/opt/brother"
    # Change default paper size to A4
    sed -i -e 's/DefaultPageSize: Letter/DefaultPageSize: A4/g' \
           -e 's/DefaultPageRegion: Letter/DefaultPageRegion: A4/g' \
           -e 's/DefaultImageableArea: Letter/DefaultImageableArea: A4/g' \
           -e 's/DefaultPaperDimension: Letter/DefaultPaperDimension: A4/g' \
           PPD/brother_dcpt300_printer_en.ppd
    sed -i 's/Letter/A4/g' ../lpr-extracted/opt/brother/Printers/dcpt300/inf/brdcpt300rc
    sed -i 's/Letter/A4/g' ../lpr-extracted/opt/brother/Printers/dcpt300/inf/setupPrintcapij
  '';

  buildPhase = ''
    runHook preBuild

    cd brcupsconfig
    make
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    mkdir -p $out/opt
    cp -r ../lpr-extracted/opt/* $out/opt/
    mkdir -p $out/opt/brother/Printers/dcpt300/cupswrapper
    install -Dm755 brcupsconfig/brcupsconfpt1 $out/opt/brother/Printers/dcpt300/cupswrapper/brcupsconfpt1
    install -Dm755 cupswrapper/brother_lpdwrapper_dcpt300 $out/opt/brother/Printers/dcpt300/cupswrapper/brother_lpdwrapper_dcpt300
    ln -s ../../../opt/brother/Printers/dcpt300/cupswrapper/brother_lpdwrapper_dcpt300 \
      $out/lib/cups/filter/brother_lpdwrapper_dcpt300
    install -Dm644 PPD/brother_dcpt300_printer_en.ppd $out/opt/brother/Printers/dcpt300/cupswrapper/brother_dcpt300_printer_en.ppd
    ln -s ../../../opt/brother/Printers/dcpt300/cupswrapper/brother_dcpt300_printer_en.ppd \
      $out/share/cups/model/brother_dcpt300_printer_en.ppd
    mkdir -p $out/bin
    ln -s $out/opt/brother/Printers/dcpt300/cupswrapper/brcupsconfpt1 $out/bin/brprintconf_dcpt300

    runHook postInstall
  '';

  postFixup = ''
    # Patching proprietary blob

    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    for bin in $out/opt/brother/Printers/dcpt300/lpd/*; do
      if file "$bin" | grep -q "ELF 32-bit"; then
        patchelf --set-interpreter "$interpreter" \
                 --set-rpath ${
                   lib.makeLibraryPath [
                     pkgsi686Linux.stdenv.cc.cc
                     pkgsi686Linux.glibc
                   ]
                 } \
                 "$bin"
      fi
    done
    wrapProgram $out/opt/brother/Printers/dcpt300/lpd/brdcpt300filter \
      --prefix PATH : $out/bin:${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          file
          perl
          gawk
          which
        ]
      } \
      --set NIX_REDIRECTS "/opt=$out/opt" \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so"
    wrapProgram $out/opt/brother/Printers/dcpt300/cupswrapper/brother_lpdwrapper_dcpt300 \
      --prefix PATH : $out/bin:${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          file
          perl
          gawk
          which
        ]
      } \
      --run "mkdir -p /tmp/brother_inf_dcpt300" \
      --run "cp -n $out/opt/brother/Printers/dcpt300/inf/* /tmp/brother_inf_dcpt300/ 2>/dev/null || true" \
      --run "chmod 666 /tmp/brother_inf_dcpt300/* 2>/dev/null || true"
    wrapProgram $out/opt/brother/Printers/dcpt300/lpd/brdcpt300filter \
      --prefix PATH : $out/bin:${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          file
          perl
          gawk
          which
        ]
      } \
      --set NIX_REDIRECTS "/opt/brother/Printers/dcpt300/inf=/tmp/brother_inf_dcpt300:/opt=$out/opt" \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so"
    for prog in \
      $out/opt/brother/Printers/dcpt300/lpd/filterdcpt300 \
      $out/opt/brother/Printers/dcpt300/lpd/psconvertij2
    do
      if [ -x "$prog" ]; then
        wrapProgram "$prog" \
          --prefix PATH : $out/bin:${
            lib.makeBinPath [
              coreutils
              ghostscript
              gnugrep
              gnused
              file
              perl
              gawk
              which
            ]
          }
      fi
    done
  '';

  meta = {
    description = "Brother DCP-T300 printer driver";
    license = with lib.licenses; [
      unfree
      gpl2Plus
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
    maintainers = with lib.maintainers; [ righita ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    homepage = "https://www.brother.com/";
    changelog = "https://support.brother.com/g/b/downloadlist.aspx?c=us_ot&lang=en&prod=dcpt300_all&os=128";
  };
})
