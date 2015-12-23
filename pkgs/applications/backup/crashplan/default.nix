{ stdenv, fetchurl, makeWrapper, jre, cpio, gawk, gnugrep, gnused, procps, swt, gtk2, glib, libXtst }:

let version = "4.5.0";

in stdenv.mkDerivation rec {
  name = "crashplan-${version}";

  crashPlanArchive = fetchurl {
    url = "https://download.crashplan.com/installs/linux/install/CrashPlan/CrashPlan_${version}_Linux.tgz";
    sha256 = "0yqmmm92gksj8mfryjkjx83zli3213fffh2g7wi52l7m3g0ajg4a";
  };

  srcs = [ crashPlanArchive ];

  meta = with stdenv.lib; {
    description = "An online/offline backup solution";
    homepage = "http://www.crashplan.org";
    license = licenses.unfree;
    maintainers = with maintainers; [ Baughn ];
  };

  buildInputs = [ makeWrapper cpio ];

  vardir = "/var/lib/crashplan";

  manifestdir = "${vardir}/manifest";

  patches = [ ./crashplan.patch ];

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
    install -D -m 755 bin/crashplan $out/bin/crashplan
    install -D -m 755 bin/crashplan-desktop $out/bin/crashplan-desktop
    install -D -m 755 bin/crashplan-setup.sh $out/bin/crashplan-setup.sh

    rm -r $out/log
    ln -s $vardir/log $out/log
    ln -s $vardir/cache $out/cache
    ln -s $vardir/backupArchives $out/backupArchives
    ln -s $vardir/~custom $out/~custom

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
    rm $out/bin/restartLinux.sh $out/bin/uninstall.sh
    mv $out/conf $out/conf.tmpl
    ln -s $vardir/conf $out/conf

    substituteInPlace $out/bin/crashplan --subst-var out
    substituteInPlace $out/bin/crashplan-desktop --subst-var out
    substituteInPlace $out/bin/crashplan-setup.sh --subst-var out

    wrapProgram $out/bin/crashplan-desktop --prefix LD_LIBRARY_PATH ":" "${gtk2}/lib:${glib}/lib:${libXtst}/lib"
  '';
}
