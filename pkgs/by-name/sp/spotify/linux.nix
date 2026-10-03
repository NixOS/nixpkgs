{
  fetchurl,
  lib,
  meta,
  pname,
  stdenv,
  makeShellWrapper,
  squashfs-tools,
  wrapGAppsHook3,

  #Spotify
  atk,
  ayatana-ido,
  cairo,
  ffmpeg_7-headless, # Requires libavcodec < 62
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libayatana-appindicator,
  libayatana-indicator,
  libdbusmenu,
  libx11,
  pango,
  pulseaudio,
  zlib,

  # CEF
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cups,
  dbus,
  expat,
  libdrm,
  libgbm,
  libGL,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxshmfence,
  nspr,
  nss_latest,
  systemdLibs,
  udev,

  # High-DPI support: Spotify's --force-device-scale-factor argument
  # not added if `null`, otherwise, should be a number.
  deviceScaleFactor ? null,
  updateScript,
}:

let
  deps = [
    # Via lddtree:
    ayatana-ido
    cairo
    gdk-pixbuf
    gtk3
    libayatana-appindicator
    libayatana-indicator
    libdbusmenu
    pango
    stdenv.cc.cc

    # Found via dlopen:
    atk
    ffmpeg_7-headless # Requires libavcodec < 62
    glib
    harfbuzz
    libx11
    pulseaudio
    zlib

    # https://github.com/NixOS/nixpkgs/blob/b6c2725f1208c66437095d28c5b84e6a173d9e3c/pkgs/by-name/ce/cef-binary/package.nix#L45
    # Copied CEF Dependencies with duplicates commented out:

    #glib
    # https://github.com/NixOS/nixpkgs/commit/699e707e90a89fb06a9880df6b83c22428fd8deb
    nss_latest
    nspr
    #atk
    at-spi2-atk
    libdrm
    expat
    libxkbcommon
    libgbm
    #gtk3
    #pango
    #cairo
    alsa-lib
    dbus
    at-spi2-core
    cups
    libGL
    udev
    systemdLibs
    libxcb
    #libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxshmfence
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname;

  # TO UPDATE: just execute the ./update.sh script (won't do anything if there is no update)
  # "rev" decides what is actually being downloaded
  # If an update breaks things, one of those might have valuable info:
  # https://aur.archlinux.org/packages/spotify/
  # https://community.spotify.com/t5/Desktop-Linux
  version = "1.2.95.453.g0eeebbed";

  # To get the latest stable revision:
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=stable' | jq '.download_url,.version,.last_updated'
  # To get general information:
  # curl -H 'Snap-Device-Series: 16' 'https://api.snapcraft.io/v2/snaps/info/spotify' | jq '.'
  # More examples of api usage:
  # https://github.com/canonical-websites/snapcraft.io/blob/master/webapp/publisher/snaps/views.py
  rev = "99";

  # fetch from snapcraft instead of the debian repository most repos fetch from.
  # That is a bit more cumbersome. But the debian repository only keeps the last
  # two versions, while snapcraft should provide versions indefinitely:
  # https://forum.snapcraft.io/t/how-can-a-developer-remove-her-his-app-from-snap-store/512

  # This is the next-best thing, since we're not allowed to re-distribute
  # spotify ourselves:
  # https://community.spotify.com/t5/Desktop-Linux/Redistribute-Spotify-on-Linux-Distributions/td-p/1695334
  src = fetchurl {
    name = "spotify-${finalAttrs.version}-${finalAttrs.rev}.snap";
    url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${finalAttrs.rev}.snap";
    hash = "sha512-IRjGDAdXY4O9KkMpNLKnPxgrQp3WmpHbaAIvM6Xq6969HON39dajHebVQAxZUvKOSWOeS9W1yn1Cl/3uFMbwsw==";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    makeShellWrapper
    squashfs-tools
  ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
    cd squashfs-root
    if ! grep -q '${finalAttrs.version}' meta/snap.yaml; then
      echo "Package version differs from version found in snap metadata:"
      grep 'version: ' meta/snap.yaml
      echo "While the nix package specifies: ${finalAttrs.version}."
      echo "You probably chose the wrong revision or forgot to update the nix version."
      exit 1
    fi
    runHook postUnpack
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv ./usr/* $out/

    chmod +w "$out/share/spotify/spotify"
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/spotify/spotify

    # fix Icon line in the desktop file (#48062)
    sed -i "s:^Icon=.*:Icon=spotify-client:" "$out/share/spotify/spotify.desktop"

    # Desktop file
    install -Dm644 "$out/share/spotify/spotify.desktop" "$out/share/applications/spotify.desktop"

    # Icons
    for i in 16 22 24 32 48 64 128 256 512; do
      ixi="$i"x"$i"
      mkdir -p "$out/share/icons/hicolor/$ixi/apps"
      ln -s "$out/share/spotify/icons/spotify-linux-$i.png" \
        "$out/share/icons/hicolor/$ixi/apps/spotify-client.png"
    done

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgramShell $out/share/spotify/spotify \
      ''${gappsWrapperArgs[@]} \
      ${
        lib.optionalString (deviceScaleFactor != null) ''
          --add-flags "--force-device-scale-factor=${toString deviceScaleFactor}" \
        ''
      } \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath deps}" \
      --run 'if [[ "''${NIXOS_OZONE_WL:-default}" == "1" ]]; then unset DISPLAY; fi'

    runHook postFixup
  '';

  passthru = { inherit updateScript; };

  meta = meta // {
    maintainers = with lib.maintainers; [
      letgamer
      ma27
    ];
  };
})
