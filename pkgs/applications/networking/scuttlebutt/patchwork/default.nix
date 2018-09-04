{ stdenv, lib, fetchurl, glibc, zlib, fuse, cairo, atk,
  pythonPackages, p7zip, udev, dbus, gtk3, pango,
  gdk_pixbuf, glib, libX11, libXScrnSaver, libXcomposite, libXcursor,
  libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXtst,
  libxcb, gnome2, nss, nspr, alsaLib, cups, fontconfig, expat, makeDesktopItem}:

let
  rpath = lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    dbus 
    expat
    fontconfig
    fuse
    gdk_pixbuf
    glib
    gtk3
    gnome2.GConf
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libxcb
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    nss
    pango
    stdenv.cc.cc 
    udev
    zlib.out
  ];

in stdenv.mkDerivation rec {
  name = "Patchwork-${version}";
  version = "3.10.1";

  src = fetchurl {
    url = "https://github.com/ssbc/patchwork/releases/download/v${version}/${name}-linux-x86_64.AppImage";
    sha256 = "18dvzh2bfmq320s2qi6cqn0qc32y9yl2wdwj518aq8bds78yqqx2";
  };

  desktopItem = makeDesktopItem {
    name = "Patchwork";
    exec = "patchwork";
    icon = "$out/share/patchwork/";
    comment = "Decentralized messanging and sharing app"; 
    desktopName = "Patchwork";
    genericName = "Patchwork";
    categories = "Network;";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase"];

  buildIntputs = [ pythonPackages.binwalk p7zip ];

  binwalk = "${pythonPackages.binwalk}/bin/binwalk";

  unpackPhase = ''
    export HOME=$(pwd) # binwalk seems unhappy without this...
    ${binwalk} $src --quiet -D 'squashfs:.squashfs:7z x %e'
    '';

  installPhase = ''
    # 
    # appName is kind of a hack. Binwalk extracted
    # the retrieved squashfs in a directory named after the
    # AppImage name (_$imagename.extracted to be exact),
    # which itself depends of its name in the nix store.
    #
    # I did not find a way to extract the data without this
    # weird folder name.
    # 
    # So we are basically looking for the name of the AppImage drv here (without the .drv)
    # to predict this directory name.
    # 
    appName=$(basename -s .drv $src)
    mkdir -p $out/{libexec,bin,share/patchwork}
    cd _$appName.extracted
    cp ssb-patchwork.png $out/share/patchwork/patchwork.png
    cp -r app/* $out/libexec/
    chmod a+x $out/libexec/ssb-patchwork
    ln -s $out/libexec/ssb-patchwork $out/bin/patchwork
  '';

  fixupPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${rpath}:$out/libexec \
      $out/libexec/ssb-patchwork 
  '';

  meta = {
    description = "A decentralized messaging and sharing app built on top of Secure Scuttlebutt (SSB)";
    homepage    = https://github.com/ssbc/patchwork;
    license     = lib.licenses.agpl3;
    maintainers = with lib.maintainers; [ cryptix ninjatrappeur ];
    platforms   = [ "x86_64-linux" ];
  };
}
