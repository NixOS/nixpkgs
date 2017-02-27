{ stdenv, requireFile, writeScript, patchelf, libredirect, coreutils, pcsclite
, zlib, glib, gdk_pixbuf, gtk2, cairo, pango, libX11, atk, openssl }:

let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc zlib glib gdk_pixbuf gtk2 cairo pango libX11 atk openssl
  ];
in

stdenv.mkDerivation rec {
  name = "moneyplex-${version}";
  version = "1.0";

  src = requireFile {
    message = ''
      Unfortunately, Matrica does not provide an installable version of moneyplex.
      To work around, install moneyplex on another system, und delete the following files
      from the moneyplex installation directory: backups, mdaten, rup, Lnx\ Global.ali, Lnx\ Local ...ali
      and settings.ini, and then pack the folder into moneyplex-${version}.tar.gz.
    '';
    name = "moneyplex-${version}.tar.gz";
    sha256 = "0wpzwvhybjbqvqi8bpvkvcs3mikvl68gk1hzawihi0xnm28lcxw0";
  };

  phases = [ "unpackPhase" "installPhase" "postInstall" ];

  buildInputs = [ ];

  installPhase =
  ''
    mkdir -p "$out/opt/moneyplex"
    cp -r . $out/opt/moneyplex

    mkdir "$out/bin"

    cat > $out/bin/moneyplex <<EOF
    #!${stdenv.shell}

    if [ -z "\$XDG_DATA_HOME" ]; then
        MDIR=\$HOME/.local/share/moneyplex
    else
        MDIR=\$XDG_DATA_HOME/moneyplex
    fi

    if [ ! -d "\$MDIR" ]; then
        ${coreutils}/bin/mkdir -p \$MDIR
        ${coreutils}/bin/cp -r $out/opt/moneyplex/* \$MDIR
        ${coreutils}/bin/chmod 0644 \$MDIR/*
        ${coreutils}/bin/chmod 0755 \$MDIR/system
        ${coreutils}/bin/chmod 0644 \$MDIR/system/*
        ${coreutils}/bin/chmod 0755 \$MDIR/reports
        ${coreutils}/bin/chmod 0644 \$MDIR/reports/*
        ${coreutils}/bin/chmod 0755 \$MDIR/moneyplex
        ${coreutils}/bin/chmod 0755 \$MDIR/prestart
        ${coreutils}/bin/chmod 0755 \$MDIR/mpxalarm
    fi

    if [ ! -d "\$MDIR/pcsc" ]; then
        ${coreutils}/bin/mkdir -p \$MDIR/pcsc
    fi
    if [ ! -e "\$MDIR/pcsc/libpcsclite.so.1" ] || [ ! \`${coreutils}/bin/readlink -f "\$MDIR/pcsc/libpcsclite.so.1"\` -ef "${pcsclite}/lib/libpcsclite.so.1" ]; then
        ${coreutils}/bin/ln -sf "${pcsclite}/lib/libpcsclite.so.1" "\$MDIR/pcsc/libpcsclite.so.1"
    fi


    if [ -e "\$MDIR/rup/rupremote.lst" ]; then
      for i in \`${coreutils}/bin/cat "\$MDIR/rup/rupremote.lst"\`; do
        ${coreutils}/bin/mv "\$MDIR/rup/"\`${coreutils}/bin/basename \$i\` "\$MDIR/\$i" 
      done
      rm -r "\$MDIR/rup/rupremote.lst"
    fi

    if [ ! -e "\$MDIR/moneyplex.patched" ] || [ "\$MDIR/moneyplex" -nt "\$MDIR/moneyplex.patched" ]; then
        ${coreutils}/bin/cp "\$MDIR/moneyplex" "\$MDIR/moneyplex.patched"
        ${coreutils}/bin/chmod 0755 "\$MDIR/moneyplex.patched"
    fi
    if [ ! \`${patchelf}/bin/patchelf --print-interpreter \$MDIR/moneyplex.patched\` = $(cat $NIX_CC/nix-support/dynamic-linker) ] ||
       [ ! \`${patchelf}/bin/patchelf --print-rpath \$MDIR/moneyplex.patched\` = "${libPath}" ]; then
        ${patchelf}/bin/patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath "${libPath}" "\$MDIR/moneyplex.patched"
    fi

    exec \$MDIR/moneyplex.patched
    EOF

    chmod +x $out/bin/moneyplex
    '';

  postInstall = ''
    mkdir -p $out/share/icons
    cp -r $out/opt/moneyplex/system/mpx256.png $out/share/icons/moneyplex.png

    mkdir -p $out/share/applications
    cat > $out/share/applications/moneyplex.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=Moneyplex
    GenericName=Moneyplex online banking software
    Comment=Online banking software
    Icon=$out/share/icons/moneyplex.png
    Exec=$out/bin/moneyplex
    Terminal=false
    Categories=Application;
    StartupNotify=true
    EOF
    '';


  meta = with stdenv.lib; {
    description = "Moneyplex online banking software";
    maintainers = with maintainers; [ tstrobel ];
    platforms = platforms.linux;
    license = licenses.unfree;
    downloadPage = http://matrica.de/download/download.html;
  };

}
