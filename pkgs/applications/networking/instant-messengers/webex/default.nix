{ lib
, writeScript
, stdenv
, fetchurl
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, libdrm
, libgcrypt
, libglvnd
, libkrb5
, libpulseaudio
, libsecret
, udev
, libxcb
, libxkbcommon
, libxcrypt-legacy
, lshw
, mesa
, nspr
, nss
, pango
, zlib
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libxshmfence
, xcbutil
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
, p7zip
, tbb
, wayland
, libXScrnSaver
}:

stdenv.mkDerivation rec {
  pname = "webex";
  version = "44.5.0.29672";

  src = fetchurl {
    url = "https://binaries.webex.com/WebexDesktop-Ubuntu-Gold/20240521091053/Webex_ubuntu.7z";
    sha256 = "e155c280d15f2db4b5e638f244319dbec938d6de267f2fed1b4ba2b55fbb8a9b";
  };

  nativeBuildInputs = [
    p7zip
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gdk-pixbuf
    gtk3
    harfbuzz
    lshw
    mesa
    nspr
    nss
    pango
    zlib
    libdrm
    libgcrypt
    libglvnd
    libkrb5
    libpulseaudio
    libsecret
    udev
    libxcb
    libxkbcommon
    libxcrypt-legacy
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxshmfence
    xcbutil
    xcbutilimage
    libXScrnSaver
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    tbb
    wayland
  ];

  libPath = "$out/opt/Webex/lib:$out/opt/Webex/bin:${lib.makeLibraryPath buildInputs}";

  unpackPhase = ''
    7z x $src
    mv Webex_ubuntu/opt .
  '';

  postPatch = ''
    substituteInPlace opt/Webex/bin/webex.desktop --replace /opt $out/opt
  '';

  dontPatchELF = true;

  buildPhase = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      opt/Webex/bin/CiscoCollabHost \
      opt/Webex/bin/CiscoCollabHostCef \
      opt/Webex/bin/CiscoCollabHostCefWM \
      opt/Webex/bin/WebexFileSelector \
      opt/Webex/bin/pxgsettings
    for each in $(find opt/Webex -type f | grep \\.so); do
      patchelf --set-rpath "${libPath}" "$each"
    done
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/applications"
    cp -r opt "$out"

    ln -s "$out/opt/Webex/bin/CiscoCollabHost" "$out/bin/webex"
    chmod +x $out/bin/webex

    mv "$out/opt/Webex/bin/webex.desktop" "$out/share/applications/webex.desktop"
  '';

  passthru.updateScript = writeScript "webex-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -eou pipefail;

    channel=gold # blue, green, gold
    manifest=$(curl -s "https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?channel=$channel&model=ubuntu" | jq '.manifest')

    url=$(jq -r '.packageLocation' <<< "$manifest")
    version=$(jq -r '.version' <<< "$manifest")
    hash=$(jq -r '.checksum' <<< "$manifest")

    update-source-version ${pname} "$version" "$hash" "$url" --file=./pkgs/applications/networking/instant-messengers/webex/default.nix
  '';

  meta = with lib; {
    description = "All-in-one app to call, meet, message, and get work done";
    homepage = "https://webex.com/";
    downloadPage = "https://www.webex.com/downloads.html";
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ uvnikita ];
    platforms = [ "x86_64-linux" ];
  };
}
