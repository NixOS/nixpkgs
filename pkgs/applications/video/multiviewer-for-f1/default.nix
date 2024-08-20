{ stdenvNoCC
, fetchurl
, lib
, makeWrapper
, autoPatchelfHook
, dpkg
, alsa-lib
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, ffmpeg
, glib
, gtk3
, libdrm
, libudev0-shim
, libxkbcommon
, mesa
, nspr
, nss
, pango
, writeScript
, xorg
}:
let
  id = "182296295";
in
stdenvNoCC.mkDerivation rec {
  pname = "multiviewer-for-f1";
  version = "1.35.4";

  src = fetchurl {
    url = "https://releases.multiviewer.dev/download/${id}/multiviewer-for-f1_${version}_amd64.deb";
    sha256 = "sha256-aDkuv4Zn2T/jS7rMRz6aR+110mfWgnkUJfx0LLP+Txg=";
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
    mesa
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
    mv -t $out/share usr/share/* usr/lib/multiviewer-for-f1

    makeWrapper "$out/share/multiviewer-for-f1/MultiViewer for F1" $out/bin/multiviewer-for-f1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libudev0-shim ]}:\"$out/share/Multiviewer for F1\""

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-multiviewer-for-f1" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts

    set -eu -o pipefail

    # Check download page for latest .deb
    link=$(curl -s "https://multiviewer.app/download" `
    | grep -Poi 'https:\/\/releases.multiviewer.app\/download\/*\d+\/multiviewer-for-f1_\d+\.\d+\.\d+_amd64.deb' `
    | head -1)

    # Pre-calculate package hash
    hash=$(nix-prefetch-url --type sha256 $link)

    # Current package version
    version=$(echo $link | grep -Poi '(\d+\.\d+\.\d+)')

    # Build ID
    id=$(echo $link | grep -Pio '(?<=\/)(\d+)(?=\/)')

    # Update ID and version in source
    update-source-version --version-key=id "$id"
    update-source-version ${pname} "$version" "$hash" --system=x86_64-linux
  '';

  meta = with lib; {
    description = "Unofficial desktop client for F1 TV®";
    homepage = "https://multiviewer.app";
    downloadPage = "https://multiviewer.app/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ babeuh ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "multiviewer-for-f1";
  };
}
