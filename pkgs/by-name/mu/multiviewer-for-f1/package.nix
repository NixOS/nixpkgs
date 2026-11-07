{
  stdenvNoCC,
  fetchurl,
  lib,
  makeWrapper,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  glib,
  gtk3,
  libdrm,
  libudev0-shim,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
  writeScript,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "multiviewer-for-f1";
  version = "2.12.0";

  src = fetchurl {
    url = "https://releases.multiviewer.app/v/2.12.0/1/96R-0C1s8UqDUXq5RCvEsGVBneRwcCF0/multiviewer_2.12.0_amd64.deb";
    hash = "sha256-eppdmS5ZdZDwwSvMDB3TZbXbbns0NvlSbCj0ydnR36A=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    glib
    gtk3
    libdrm
    libxkbcommon
    libgbm
    nspr
    nss
    pango
    libx11
    libxcomposite
    libxcb
    libxdamage
    libxext
    libxfixes
    libxrandr
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    mv -t $out/share usr/share/* usr/lib/multiviewer

    makeWrapper "$out/share/multiviewer/multiviewer" $out/bin/multiviewer \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libudev0-shim ]}:\"$out/share/multiviewer\""

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-multiviewer-for-f1" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    set -eu -o pipefail

    # Get latest API for packages, store so we only make one request
    latest=$(curl -s "https://api.multiviewer.app/api/v1/releases/latest?channel=stable")

    # From the downloaded JSON extract the url, version and id
    link=$(echo $latest | jq -r '.downloads[] | select(.platform=="linux_deb").url')
    version=$(echo $latest | jq -r '.version')

    if [ "$version" != "${finalAttrs.version}" ]
    then
      # Pre-calculate package hash
      hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url --type sha256 $link))

      # Update URL and version in source
      update-source-version ${finalAttrs.pname} "$version" "$hash" "$link" --system=x86_64-linux
    fi
  '';

  meta = {
    description = "Unofficial desktop client for F1 TV";
    homepage = "https://multiviewer.app";
    downloadPage = "https://multiviewer.app/download";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      babeuh
      eprovst
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "multiviewer";
  };
})
