{ stdenv, fetchurl, makeWrapper, jre, cpio, gawk, gnugrep, gnused, procps, swt, gtk2, glib, libXtst }:

let version = "3.6.4";

in stdenv.mkDerivation rec {
  name = "crashplan-${version}";

  crashPlanArchive = fetchurl {
    url = "http://download.crashplan.com/installs/linux/install/CrashPlan/CrashPlan_${version}_Linux.tgz";
    sha256 = "0xmzpxfm8vghk552jy167wg1nky1pp93dqds1p922hn73g0x5cv3";
  };

  srcs = [ crashPlanArchive ];

  meta = with stdenv.lib; {
    description = "An online/offline backup solution";
    homepage = "http://www.crashplan.org";
    license = licenses.unfree;
    maintainers = with maintainers; [ sztupi ];
  };

  buildInputs = [ makeWrapper cpio ];

  vardir = "/var/lib/crashplan";

  manifestdir = "${vardir}/manifest";

  patches = [ ./CrashPlanEngine.patch ];

  installPhase = ''
    mkdir $out
    zcat -v CrashPlan_${version}.cpi | (cd $out; cpio -i -d -v --no-preserve-owner)

    # sed -i "s|<manifestPath>manifest</manifestPath>|<manifestPath>${manifestdir}</manifestPath>|g" $out/conf/default.service.xml

    # Fix for encoding troubles (CrashPlan ticket 178827)
    # Make sure the daemon is running using the same localization as
    # the (installing) user
    echo "" >> run.conf
    echo "export LC_ALL=en_US.UTF-8" >> run.conf

    install -d -m 755 unpacked $out

    install -D -m 644 EULA.txt $out/EULA.txt
    install -D -m 644 run.conf $out/bin/run.conf
    install -D -m 755 scripts/CrashPlanDesktop $out/bin/CrashPlanDesktop
    install -D -m 755 scripts/CrashPlanEngine $out/bin/CrashPlanEngine

    rm -r $out/log
    ln -s $vardir/log $out/log
    ln -s $vardir/cache $out/cache
    ln -s $vardir/backupArchives $out/backupArchives
    ln -s $vardir/conf/service.model $out/conf/service.model
    ln -s $vardir/conf/my.service.xml $out/conf/my.service.xml

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
    for f in $out/bin/CrashPlanDesktop $out/bin/CrashPlanEngine; do
      echo "substitutions in $f"
      substituteInPlace $f --replace /bin/ps  ${procps}/bin/ps
      substituteInPlace $f --replace awk      ${gawk}/bin/awk
      substituteInPlace $f --replace sed      ${gnused}/bin/sed
      substituteInPlace $f --replace grep     ${gnugrep}/bin/grep
    done

    wrapProgram $out/bin/CrashPlanDesktop --prefix LD_LIBRARY_PATH ":" "${gtk2}/lib:${glib}/lib:${libXtst}/lib"
  '';
}
