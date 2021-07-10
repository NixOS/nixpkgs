{ lib, stdenv, fetchurl, patchelf, makeDesktopItem
, alsa-lib, at-spi2-atk, at-spi2-core, atk, cups, dbus, expat, fontconfig
, freetype, glib, harfbuzz, libdrm, libgcrypt, libglvnd, libkrb5, libpulseaudio
, libsecret, udev, libxcb, libxkbcommon, lshw, mesa, nspr, nss, pango, zlib
, libX11, libXcomposite, libXcursor, libXdamage, libXext , libXfixes, libXi
, libXrandr, libXrender, libXtst, libxshmfence, xcbutil , xcbutilimage
, xcbutilkeysyms, xcbutilrenderutil, xcbutilwm, p7zip, wayland
, enableWayland ? false
}:

let
  inherit (lib) optional;
  name = "Webex";
  binaryName = "CiscoCollabHost";
  versionSpec = builtins.fromJSON (builtins.readFile ./version.json);

in stdenv.mkDerivation rec {
  pname = "webex";
  version = versionSpec.version;

  src = fetchurl {
    url = versionSpec.packageLocation;
    sha256 = versionSpec.checksum;
  };

  nativeBuildInputs = [ patchelf ];

  buildInputs = [ alsa-lib at-spi2-atk at-spi2-core atk cups dbus expat
                  fontconfig freetype glib harfbuzz lshw mesa nspr nss pango
                  zlib libdrm libgcrypt libglvnd libkrb5 libpulseaudio libsecret
                  udev libxcb libxkbcommon libX11 libXcomposite libXcursor
                  libXdamage libXext libXfixes libXi libXrandr libXrender
                  libXtst libxshmfence xcbutil xcbutilimage xcbutilkeysyms
                  xcbutilrenderutil xcbutilwm p7zip]
        ++ optional enableWayland wayland;

  libPath = lib.makeLibraryPath buildInputs
          + ":$out/opt/Webex/lib"
          + ":$out/opt/Webex/bin";

  unpackPhase = ''
    7z x $src
    mv Webex_ubuntu/opt .
  '';

  dontPatchELF = true;
  dontStrip    = true;

  buildPhase = ''
    echo "Patching executables"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      opt/Webex/bin/CiscoCollabHost \
      opt/Webex/bin/CiscoCollabHostCef \
      opt/Webex/bin/CiscoCollabHostCefWM \
      opt/Webex/bin/WebexFileSelector \
      opt/Webex/bin/pxgsettings
    echo "Patching libraries"
    for each in $(find opt/Webex -type f | grep \\.so); do
      echo "Patching $each"
      patchelf --set-rpath "${libPath}" "$each"
    done
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r opt "$out"
    mkdir "$out/bin"
    ln -s "$out/opt/Webex/bin/${binaryName}" "$out/bin/${pname}"
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" $out/share/
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    cp ${./webex.svg} "$out/share/icons/hicolor/scalable/apps/webex.svg"
  '';

  desktopItem = makeDesktopItem {
    name = name;
    exec = pname;
    icon = pname;
    desktopName = name;
    genericName = meta.description;
    categories = "Network;InstantMessaging;";
    mimeType = "x-scheme-handler/webex";
  };

  meta = with lib; {
    description = "Cisco Webex collaboration application";
    homepage = "https://webex.com/";
    downloadPage = "https://www.webex.com/downloads.html";
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ myme uvnikita ];
    platforms = [ "x86_64-linux" ];
  };
}
