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
  xorg,
  writeScript,
}:
let
  id = "289869947";
in
stdenvNoCC.mkDerivation rec {
  pname = "multiviewer-for-f1";
  version = "2.1.0";

  src = fetchurl {
    url = "https://releases.multiviewer.dev/download/${id}/multiviewer_${version}_amd64.deb";
    sha256 = "sha256-H+tt2FiT1UxkWBxpuyOIUjRMOMl7kN/SFH/WqoRdVUU=";
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
    xorg.libX11
    xorg.libXcomposite
    xorg.libxcb
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
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
    #!nix-shell -i bash -p curl common-updater-scripts
    set -eu -o pipefail

    # Get latest API for packages, store so we only make one request
    latest=$(curl -s "https://api.multiviewer.app/api/v1/releases/latest/")

    # From the downloaded JSON extract the url, version and id
    link=$(echo $latest | jq -r '.downloads[] | select(.platform=="linux_deb").url')
    id=$(echo $latest | jq -r '.downloads[] | select(.platform=="linux_deb").id')
    version=$(echo $latest | jq -r '.version')

    if [ "$version" != "${version}" ]
    then
      # Pre-calculate package hash
      hash=$(nix-prefetch-url --type sha256 $link)

      # Update ID and version in source
      update-source-version ${pname} "$id" --version-key=id
      update-source-version ${pname} "$version" "$hash" --system=x86_64-linux
    fi
  '';

  meta = with lib; {
    description = "Unofficial desktop client for F1 TV";
    homepage = "https://multiviewer.app";
    downloadPage = "https://multiviewer.app/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ babeuh ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "multiviewer";
  };
}
