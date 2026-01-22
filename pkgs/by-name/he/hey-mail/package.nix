{
  lib,
  stdenv,
  fetchurl,
  squashfsTools,
  makeWrapper,
  autoPatchelfHook,
  c-ares,
  gtk3-x11,
  glib,
  imagemagick,
  libevent,
  libdrm,
  libvpx,
  libxslt,
  libnotify,
  libappindicator-gtk2,
  libappindicator-gtk3,
  libxkbcommon,
  libGL,
  wrapGAppsHook3,
  writeScript,
  atk,
  libgbm,
  cups,
  systemd,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  gdk-pixbuf,
  pango,
  cairo,
  xorg,
  ffmpeg,
  http-parser,
  nss,
  nspr,
  dbus,
  expat,
}:
let
  deps = [
    c-ares
    gtk3-x11
    glib
    libevent
    libdrm
    libvpx
    libxslt
    libnotify
    libappindicator-gtk2
    libappindicator-gtk3
    libxkbcommon
    libGL
    atk
    libgbm
    cups
    systemd
    alsa-lib
    at-spi2-atk
    at-spi2-core
    gdk-pixbuf
    pango
    cairo
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXrandr
    ffmpeg
    http-parser
    nss
    nspr
    dbus
    expat
    stdenv.cc.cc
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hey-mail";
  version = "1.2.17";
  rev = "28";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/lfWUNpR7PrPGsDfuxIhVxbj0wZHoH7bK_${finalAttrs.rev}.snap";
    hash = "sha512-X4iJ8r0VFHD+dtFkyABUEFeoI3CSpmT70JjgJGsW7nqzCLriF4eekdHKJgySusnLW250RlEVtEO5wKMW+2bqCQ==";
  };

  nativeBuildInputs = [
    squashfsTools
    makeWrapper
    autoPatchelfHook
    wrapGAppsHook3
    imagemagick
  ];

  buildInputs = deps;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/share/applications/ $out/share/icons/ $out/bin
    mv ./* $out/

    ln -s $out/meta/snap.yaml $out/snap.yaml

    librarypath="${lib.makeLibraryPath deps}"

    wrapProgram $out/hey-mail \
      --prefix LD_LIBRARY_PATH : "$librarypath"

    ln -s $out/hey-mail $out/bin/hey-mail

    # fix icon line in the desktop file
    sed -i "s:^Icon=.*:Icon=hey-mail:" "$out/meta/gui/hey-mail.desktop"

    # Copy desktop file
    cp "$out/meta/gui/hey-mail.desktop" "$out/share/applications/"

    runHook postInstall
  '';

  postInstall = ''
    for i in 16 24 32 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick $out/meta/gui/icon.png -background none -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/hey-mail.png
    done
  '';

  passthru.updateScript = writeScript "update-hey-mail" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq

    set -eu -o pipefail

    data=$(curl -H 'X-Ubuntu-Series: 16' \
    'https://api.snapcraft.io/api/v1/snaps/details/hey-mail?fields=download_sha512,revision,version')

    version=$(jq -r .version <<<"$data")

    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then

        revision=$(jq -r .revision <<<"$data")
        hash=$(nix --extra-experimental-features nix-command hash to-sri "sha512:$(jq -r .download_sha512 <<<"$data")")

        update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$hash"
        update-source-version --ignore-same-hash --version-key=rev "$UPDATE_NIX_ATTR_PATH" "$revision" "$hash"

    fi
  '';

  meta = {
    homepage = "https://hey.com";
    description = "Desktop client for HEY email";
    license = lib.licenses.unfree;
    mainProgram = "hey-mail";
    maintainers = [ lib.maintainers.peret ];
    platforms = [ "x86_64-linux" ];
  };
})
