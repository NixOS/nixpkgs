{ stdenv, fetchurl, makeWrapper, getopt, jre, cpio, gawk, gnugrep, gnused, 
  procps, which, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, 
  fontconfig, dbus, gconf, nss, nspr, alsaLib, cups, expat, libudev, 
  libX11, libxcb, libXi, libXcursor, libXdamage, libXrandr, libXcomposite, 
  libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nodePackages,
  maxRam ? "1024m" }:

stdenv.mkDerivation rec {
  version = "6.6.0";
  rev = "1506661200660_4347";
  pname = "CrashPlanSmb";
  name = "${pname}_${version}_${rev}";
  
  src = fetchurl {
    url = "https://web-eam-msp.crashplanpro.com/client/installers/${name}_Linux.tgz";
    sha256 = "1zzx60fpmi2nlzpq80x4hfgspsrgd7ycfcvc6w391wxr0qzf2i9k";
  };

  nativeBuildInputs = [ makeWrapper cpio nodePackages.asar ];
  buildInputs = [ getopt which ];

  vardir = "/var/lib/crashplan";
  manifestdir = "${vardir}/manifest";
  
  postPatch = ''
    # patch scripts/CrashPlanEngine
    substituteInPlace scripts/CrashPlanEngine \
      --replace /bin/ps ${procps}/bin/ps \
      --replace awk ${gawk}/bin/awk \
      --replace '`sed' '`${gnused}/bin/sed' \
      --replace grep ${gnugrep}/bin/grep \
      --replace TARGETDIR/log VARDIR/log \
      --replace TARGETDIR/\''${NAME} VARDIR/\''${NAME} \
      --replace \$TARGETDIR/bin/run.conf $out/bin/run.conf \
      --replace \$VARDIR ${vardir}

    # patch scripts/CrashPlanDesktop
    substituteInPlace scripts/CrashPlanDesktop \
      --replace awk ${gawk}/bin/awk \
      --replace "\"\$SCRIPTDIR/..\"" "$out" \
      --replace "\$(dirname \$SCRIPT)" "$out" \
      --replace "\''${TARGETDIR}/log" ${vardir}/log \
      --replace "\''${TARGETDIR}" "$out"
  '';

  installPhase = ''
    mkdir $out
    zcat -v ${pname}_${version}.cpi | (cd $out; cpio -i -d -v --no-preserve-owner)

    install -D -m 755 scripts/CrashPlanDesktop $out/bin/CrashPlanDesktop
    install -D -m 755 scripts/CrashPlanEngine $out/bin/CrashPlanEngine
    install -D -m 644 scripts/run.conf $out/bin/run.conf
    install -D -m 644 scripts/CrashPlan.desktop $out/share/applications/CrashPlan.desktop

    # unpack, patch and repack app.asar to stop electron from creating /usr/local/crashplan/log to store the ui logs.
    asar e $out/app.asar $out/app.asar-unpacked
    rm -v $out/app.asar
    substituteInPlace $out/app.asar-unpacked/shared_modules/shell/platform_paths.js \
      --replace "getLogFileParentPath();" "\"$vardir/log\";"
    asar p $out/app.asar-unpacked $out/app.asar

    mv -v $out/*.asar $out/electron/resources
    chmod 755 "$out/electron/crashplan"

    rm -r $out/log
    mv -v $out/conf $out/conf.template
    ln -s $vardir/log $out/log
    ln -s $vardir/cache $out/cache
    ln -s $vardir/conf $out/conf

    substituteInPlace $out/bin/run.conf \
      --replace "-Xmx1024m" "-Xmx${maxRam}"

    echo "JAVACOMMON=${jre}/bin/java" > $out/install.vars
    echo "APP_BASENAME=CrashPlan" >> $out/install.vars
    echo "TARGETDIR=$out" >> $out/install.vars
    echo "BINSDIR=$out/bin" >> $out/install.vars
    echo "MANIFESTDIR=${manifestdir}" >> $out/install.vars
    echo "VARDIR=${vardir}" >> $out/install.vars
    echo "INITDIR=" >> $out/install.vars
    echo "RUNLVLDIR=" >> $out/install.vars
    echo "INSTALLDATE=" >> $out/install.vars

  '';

  postFixup = ''
    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 $out/electron/crashplan
    wrapProgram $out/bin/CrashPlanDesktop --prefix LD_LIBRARY_PATH ":" "${stdenv.lib.makeLibraryPath [ 
      stdenv.cc.cc.lib gtk2 atk glib pango gdk_pixbuf cairo freetype 
      fontconfig dbus gconf nss nspr alsaLib cups expat libudev 
      libX11 libxcb libXi libXcursor libXdamage libXrandr libXcomposite 
      libXext libXfixes libXrender libXtst libXScrnSaver]}"
  '';

  meta = with stdenv.lib; {
    description = "An online backup solution";
    homepage = http://www.crashplan.com/business/;
    license = licenses.unfree;
    maintainers = with maintainers; [ xvapx ];
  };

}