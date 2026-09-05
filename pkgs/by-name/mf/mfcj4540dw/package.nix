{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  perl,
  bbe,
  cups,
  ghostscript,
  which,
  gnused,
  gnugrep,
  coreutils-full,
  autoPatchelfHook,
}:
let
  # Driver information
  driverModel = "mfcj4540dw";
  driverVersion = "3.5.0-1";
  driverPrinterDir = "opt/brother/Printers";
  driverArch = builtins.elemAt (lib.splitString "-" stdenv.hostPlatform.system) 0;
  driverInfDir = "${driverPrinterDir}/${driverModel}/inf";
  driverLpDir = "${driverPrinterDir}/${driverModel}/lpd";
  driverCupsWrapper = "${driverPrinterDir}/${driverModel}/cupswrapper";
  debugLvl = "0"; # Once you're done debugging set this to 0 (cups reads from stdout of the wrapper, so the logs break it if left enabled)
in
stdenv.mkDerivation {
  pname = driverModel;
  version = driverVersion;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105305/${driverModel}pdrv-${driverVersion}.i386.deb";
    hash = "sha256-pdo/UWsAdZeebSXD9tReiA73qkhuclzt/CDXy50NunQ=";
  };

  unpackPhase = ''
    dpkg -x $src .
  '';

  nativeBuildInputs = [
    bbe
    dpkg
    makeWrapper
    perl
    autoPatchelfHook
  ];

  buildInputs = [
    cups
    perl
    stdenv.cc.libc
    ghostscript
    which
    gnused
    gnugrep
    coreutils-full
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  patchPhase = ''
    WRAPPER=${driverCupsWrapper}/brother_lpdwrapper_${driverModel}

    # Patching paths in scripts and setting debug level
    substituteInPlace $WRAPPER \
      --replace-fail "basedir =~" "basedir = \"$out/${driverPrinterDir}/${driverModel}\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"${driverModel}\"; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};" \
      --replace-fail 'my $LPDFILTER   =$basedir."lpd/filter_".$PRINTER;' 'my $LPDFILTER   =$basedir."/lpd/filter_".$PRINTER;' \
      --replace-fail "\`cp " "\`cp -p " \
      --replace-fail "\$TEMPRC\`" "\$TEMPRC; chmod a+rw \$TEMPRC\`" \
      --replace-fail "\`mv " "\`cp -p "

    substituteInPlace ${driverInfDir}/setupPrintcapij \
      --replace-fail "/etc/printcap" "$out/etc/printcap" \
      --replace-fail "/${driverPrinterDir}" "$out/${driverPrinterDir}" \
      --replace-fail "/var/spool/lpd" "$out/var/spool/lpd"

    substituteInPlace ${driverCupsWrapper}/cupswrapper${driverModel} \
      --replace-fail "/usr/share" "$out/share"

    substituteInPlace ${driverLpDir}/filter_${driverModel} \
      --replace-fail 'PRINTER =~' 'PRINTER = "${driverModel}"; #'\
      --replace-fail "BR_PRT_PATH =~ " "BR_PRT_PATH = \"$out/${driverPrinterDir}/${driverModel}\"; #"\
      --replace-fail "my \$BRCONV=" "my \$BRCONV=\"$out/${driverLpDir}/br${driverModel}filter\"; #"\
      --replace-fail "\$PAPERINF=" "\$PAPERINF=\"$out/${driverInfDir}/paperinfij2\" ;#"\
      --replace-fail "\$IMAGABLE=" "\$IMAGABLE=\"$out/${driverInfDir}/ImagingArea\" ;#"

    # Patching hard-coded paths in binary ELFs
    files=(${driverLpDir}/${driverArch}/br${driverModel}filter ${driverLpDir}/${driverArch}/brprintconf_${driverModel})
    search="/opt/brother/Printers/"
    replace="lopt/brother/Printers/"
    for f in "''${files[@]}"; do
        bbe -e "s|$search|$replace|" "$f" -o "$f.tmp" && mv "$f.tmp" "$f"
        chmod +x "$f"
    done
  '';

  installPhase = ''
    CUPSFILTER_DIR=$out/lib/cups/filter
    CUPSPPD_DIR=$out/share/cups/model

    runHook preInstall

    mkdir -p $out
    cp -rp ./opt $out/
    mkdir -p $out/var/spool/lpd $out/etc $out/share $out/bin $CUPSFILTER_DIR $CUPSPPD_DIR
    ln -s $out/opt $out/lopt

    # The scripts use core utilities, add them to the path.
    makeWrapper \
      $out/${driverCupsWrapper}/brother_lpdwrapper_${driverModel} \
      $CUPSFILTER_DIR/brother_lpdwrapper_${driverModel} \
      --prefix PATH : ${coreutils-full}/bin \
      --prefix PATH : ${gnused}/bin \
      --prefix PATH : ${gnugrep}/bin

    wrapProgram $out/${driverLpDir}/filter_${driverModel} \
      --prefix PATH ":" "${ghostscript}/bin" \
      --prefix PATH ":" "${which}/bin"

    # Install cups ppd file
    ln -s $out/${driverCupsWrapper}/brother_${driverModel}_printer_en.ppd $CUPSPPD_DIR

    # Follow steps in the deb postinst script.
    ## postinst:4, also chdir so that the path patch from patchPhase works correctly
    mkdir -p $out/${driverLpDir}
    makeWrapper $out/${driverLpDir}/${driverArch}/br${driverModel}filter \
      $out/${driverLpDir}/br${driverModel}filter \
       --chdir $out

    makeWrapper $out/${driverLpDir}/${driverArch}/brprintconf_${driverModel} \
      $out/${driverLpDir}/brprintconf_${driverModel} \
      --chdir $out

    ## postinst:11
    $out/${driverInfDir}/setupPrintcapij ${driverModel} -i
    ## postinst:12
    $out/${driverCupsWrapper}/cupswrapper${driverModel}

    ## postinst:14-22 selinux stuff I couldn't be bothered with
    ## postinst:23
    ln -s $out/${driverLpDir}/brprintconf_${driverModel} $out/bin/brprintconf_${driverModel}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brother MFC-J4540DW driver";
    downloadPage = "https://www.brother.com.au/en/support/mfc-j4540dw/downloads";
    homepage = "http://www.brother.com/";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.TwoUnderscorez ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
