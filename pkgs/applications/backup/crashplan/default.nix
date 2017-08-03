{ stdenv, fetchurl, makeWrapper, jre, cpio, gawk, gnugrep, gnused, procps, swt, gtk2, glib, libXtst }:

stdenv.mkDerivation rec {
  version = "4.8.3";
  rev = "1"; #tracks unversioned changes that occur on download.code42.com from time to time
  name = "crashplan-${version}-r${rev}";

  src = fetchurl {
    url = "https://download.code42.com/installs/linux/install/CrashPlan/CrashPlan_${version}_Linux.tgz";
    sha256 = "c25d87ec1d442a396b668547e39b70d66dcfe02250cc57a25916ebb42a407113";
  };

  meta = with stdenv.lib; {
    description = "An online/offline backup solution";
    homepage = http://www.crashplan.org;
    license = licenses.unfree;
    maintainers = with maintainers; [ sztupi domenkozar jerith666 ];
  };

  buildInputs = [ makeWrapper cpio ];

  vardir = "/var/lib/crashplan";

  manifestdir = "${vardir}/manifest";

  patches = [ ./CrashPlanEngine.patch ./CrashPlanDesktop.patch ];

  installPhase = ''
    mkdir $out
    zcat -v CrashPlan_${version}.cpi | (cd $out; cpio -i -d -v --no-preserve-owner)

    # sed -i "s|<manifestPath>manifest</manifestPath>|<manifestPath>${manifestdir}</manifestPath>|g" $out/conf/default.service.xml

    # Fix for encoding troubles (CrashPlan ticket 178827)
    # Make sure the daemon is running using the same localization as
    # the (installing) user
    echo "" >> run.conf
    echo "LC_ALL=en_US.UTF-8" >> run.conf

    install -d -m 755 unpacked $out

    install -D -m 644 run.conf $out/bin/run.conf
    install -D -m 755 scripts/CrashPlanDesktop $out/bin/CrashPlanDesktop
    install -D -m 755 scripts/CrashPlanEngine $out/bin/CrashPlanEngine
    install -D -m 644 scripts/CrashPlan.desktop $out/share/applications/CrashPlan.desktop

    rm -r $out/log
    mv -v $out/conf $out/conf.template
    ln -s $vardir/log $out/log
    ln -s $vardir/cache $out/cache
    ln -s $vardir/backupArchives $out/backupArchives
    ln -s $vardir/conf $out/conf

    echo "JAVACOMMON=${jre}/bin/java" > $out/install.vars
    echo "APP_BASENAME=CrashPlan" >> $out/install.vars
    echo "TARGETDIR=${vardir}" >> $out/install.vars
    echo "BINSDIR=$out/bin" >> $out/install.vars
    echo "MANIFESTDIR=${manifestdir}" >> $out/install.vars
    echo "VARDIR=${vardir}" >> $out/install.vars
    echo "INITDIR=" >> $out/install.vars
    echo "RUNLVLDIR=" >> $out/install.vars
    echo "INSTALLDATE=" >> $out/install.vars
  '';

  postFixup = ''
    for f in $out/bin/CrashPlanDesktop $out/bin/CrashPlanEngine; do
      echo "substitutions in $f"
      substituteInPlace $f --replace /bin/ps  ${procps}/bin/ps
      substituteInPlace $f --replace awk      ${gawk}/bin/awk
      substituteInPlace $f --replace sed      ${gnused}/bin/sed
      substituteInPlace $f --replace grep     ${gnugrep}/bin/grep
    done
    
    substituteInPlace $out/share/applications/CrashPlan.desktop \
      --replace /usr/local  $out \
      --replace crashplan/skin skin \
      --replace bin/CrashPlanDesktop CrashPlanDesktop

    wrapProgram $out/bin/CrashPlanDesktop --prefix LD_LIBRARY_PATH ":" "${stdenv.lib.makeLibraryPath [ gtk2 glib libXtst ]}"
  '';
}
