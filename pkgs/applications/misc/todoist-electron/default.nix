{ stdenv, lib, fetchurl, makeDesktopItem, dpkg, atk, at-spi2-atk, glib, pango, gdk-pixbuf
, gtk3, cairo, freetype, fontconfig, dbus, xorg, nss, nspr, alsaLib, cups, expat
, udev, libpulseaudio, utillinux, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "todoist-electron";
  version = "1.24.0";

  src = fetchurl {
    url = "https://github.com/KryDos/todoist-linux/releases/download/${version}/Todoist_${version}_amd64.deb";
    sha256 = "0g35518z6nf6pnfyx4ax75rq8b8br72mi6wv6jzgac9ric1q4h2s";
  };

  desktopItem = makeDesktopItem {
    name = "Todoist";
    exec = "todoist %U";
    icon = "todoist";
    comment = "Todoist for Linux";
    desktopName = "Todoist";
    categories = "Utility";
  };

  nativeBuildInputs = [ makeWrapper dpkg ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = let
    libPath = lib.makeLibraryPath ([
      stdenv.cc.cc gtk3 atk at-spi2-atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
      nss nspr alsaLib libpulseaudio cups expat udev utillinux
    ] ++ (with xorg; [
      libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
      libXrender libX11 libXtst libXScrnSaver
    ]));
  in ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    mv usr/share "$out/share"

    # Patch binary
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:\$ORIGIN" \
      $out/opt/Todoist/todoist

    # Hacky workaround for RPATH problems
    makeWrapper $out/opt/Todoist/todoist $out/bin/todoist \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpulseaudio udev ]}

    # Desktop item
    mkdir -p "$out/share"
    rm -r "$out/share/applications"
    cp -r "${desktopItem}/share/applications" "$out/share/applications"
  '';

  meta = with lib; {
    homepage = "https://github.com/KryDos/todoist-linux";
    description = "The Linux wrapper for Todoist web version";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    maintainers = with maintainers; [ i077 ];
  };
}
