{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, makeWrapper
, nixosTests
, gtk3
, atk
, at-spi2-atk
, cairo
, pango
, pipewire
, gdk-pixbuf
, glib
, freetype
, fontconfig
, dbus
, libX11
, xorg
, libXi
, libXcursor
, libXdamage
, libXrandr
, libXcomposite
, libXext
, libXfixes
, libXrender
, libXtst
, libXScrnSaver
, nss
, nspr
, alsa-lib
, cups
, expat
, libuuid
, at-spi2-core
, libappindicator-gtk3
, mesa
  # Runtime dependencies:
, systemd
, libnotify
, libdbusmenu
, libpulseaudio
, xdg-utils
, wayland
}:

{ pname
, dir
, version
, hash
, url
}:

let
  inherit (stdenv) targetPlatform;
  ARCH = if targetPlatform.isAarch64 then "arm64" else "x64";
in
stdenv.mkDerivation rec {
  inherit pname version;

  # Please backport all updates to the stable channel.
  # All releases have a limited lifetime and "expire" 90 days after the release.
  # When releases "expire" the application becomes unusable until an update is
  # applied. The expiration date for the current release can be extracted with:
  # $ grep -a "^{\"buildExpiration" "${signal-desktop}/lib/${dir}/resources/app.asar"
  # (Alternatively we could try to patch the asar archive, but that requires a
  # few additional steps and might not be the best idea.)

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    (wrapGAppsHook.override { inherit makeWrapper; })
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
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator-gtk3
    libnotify
    libuuid
    mesa # for libgbm
    nspr
    nss
    pango
    systemd
    xorg.libxcb
    xorg.libxshmfence
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    libappindicator-gtk3
    libnotify
    libdbusmenu
    xdg-utils
    wayland
  ];

  unpackPhase = "dpkg-deb -x $src .";

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  # We need to run autoPatchelf manually with the "no-recurse" option, see
  # https://github.com/NixOS/nixpkgs/pull/78413 for the reasons.
  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    mv usr/share $out/share
    mv "opt/${dir}" "$out/lib/${dir}"

    # Note: The following path contains bundled libraries:
    # $out/lib/${dir}/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/
    # We run autoPatchelf with the "no-recurse" option to avoid picking those
    # up, but resources/app.asar still requires them.

    # Symlink to bin
    mkdir -p $out/bin
    ln -s "$out/lib/${dir}/${pname}" $out/bin/${pname}

    # Create required symlinks:
    ln -s libGLESv2.so "$out/lib/${dir}/libGLESv2.so.2"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc pipewire ] }"
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    )

    # Fix the desktop link
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "/opt/${dir}/${pname}" $out/bin/${pname} \
      --replace-fail "StartupWMClass=Signal" "StartupWMClass=signal"

    autoPatchelf --no-recurse -- "$out/lib/${dir}/"
    patchelf --add-needed ${libpulseaudio}/lib/libpulse.so "$out/lib/${dir}/resources/app.asar.unpacked/node_modules/@signalapp/ringrtc/build/linux/libringrtc-${ARCH}.node"
  '';

  passthru = {
    # Tests if the application launches and waits for "Link your phone to Signal Desktop":
    tests.application-launch = nixosTests.signal-desktop;
    updateScript.command = [ ./update.sh ];
  };

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage = "https://signal.org/";
    changelog = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eclairevoyant mic92 equirosa urandom bkchr ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
