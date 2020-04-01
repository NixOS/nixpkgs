{ stdenv, lib, fetchurl, makeDesktopItem, dpkg, atk, at-spi2-atk, glib, pango, gdk-pixbuf
, gtk3, cairo, freetype, fontconfig, dbus, xorg, nss, nspr, alsaLib, cups, expat
, udev, libpulseaudio, utillinux, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "todoist-electron";
  version = "1.19";

  src = fetchurl {
    url = "https://github.com/KryDos/todoist-linux/releases/download/${version}/Todoist_${version}.0_amd64.deb";
    sha256 = "1w0l7k7wmbhwzv71cffsir0q7zg9m0617fmyvd4a01b6flpxrpfx";
  };

  desktopItem = makeDesktopItem {
    name = "Todoist";
    exec = "todoist";
    desktopName = "Todoist";
    categories = "Utility;Productivity";
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
    ln -s "${desktopItem}/share/applications" "$out/share/applications"
  '';

  meta = with lib; {
    homepage = "https://github.com/KryDos/todoist-linux";
    description = "The Linux wrapper for Todoist web version";
    platforms = [ "x86_64-linux" ];
    license = licenses.isc;
    maintainers = with maintainers; [ i077 ];
  };
}
