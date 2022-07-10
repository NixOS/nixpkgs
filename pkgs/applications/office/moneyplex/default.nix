{ lib, stdenv, fetchurl, patchelf, coreutils, pcsclite
, zlib, glib, gdk-pixbuf, gtk2, cairo, pango, libX11, atk, openssl
, runtimeShell }:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc zlib glib gdk-pixbuf gtk2 cairo pango libX11 atk openssl
  ];

  src_i686 = {
    url = "http://www.matrica.com/download/distribution/moneyplex_16_install32_22424.tar.gz";
    sha256 = "0yfpc6s85r08g796dycl378kagkma865vp7j72npia3hjc4vwamr";
  };

  src_x86_64 = {
    url = "http://www.matrica.com/download/distribution/moneyplex_16_install64_22424.tar.gz";
    sha256 = "03vxbg1yp8qyvcn6bw2a5s134nxzq9cn0vqbmlld7hh4knbsfqzw";
  };
in

stdenv.mkDerivation {
  pname = "moneyplex";
  version = "16.0.22424";

  src = fetchurl (if stdenv.hostPlatform.system == "i686-linux" then src_i686
                  else if stdenv.hostPlatform.system == "x86_64-linux" then src_x86_64
                  else throw "moneyplex requires i686-linux or x86_64-linux");


  phases = [ "unpackPhase" "installPhase" "postInstall" ];

  buildInputs = [ ];

  installPhase =
  ''
    mkdir -p "$out/opt/moneyplex"
    cp -r . $out/opt/moneyplex

    mkdir "$out/bin"

    cat > $out/bin/moneyplex <<EOF
    #!${runtimeShell}

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
    if [ ! -e "\$MDIR/pcsc/libpcsclite.so.1" ] || [ ! \`${coreutils}/bin/readlink -f "\$MDIR/pcsc/libpcsclite.so.1"\` -ef "${lib.getLib pcsclite}/lib/libpcsclite.so.1" ]; then
        ${coreutils}/bin/ln -sf "${lib.getLib pcsclite}/lib/libpcsclite.so.1" "\$MDIR/pcsc/libpcsclite.so.1"
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


  meta = with lib; {
    description = "Moneyplex online banking software";
    maintainers = with maintainers; [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    license = licenses.unfree;
    downloadPage = "http://matrica.de/download/download.html";
  };

}
