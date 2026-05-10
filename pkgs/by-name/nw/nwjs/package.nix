{
  alsa-lib,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  buildEnv,
  buildPackages,
  cairo,
  cups,
  dbus,
  expat,
  fetchurl,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  lib,
  libcap,
  libdrm,
  libGL,
  libnotify,
  libuuid,
  libxcb,
  libxkbcommon,
  makeWrapper,
  libgbm,
  nspr,
  nss,
  pango,
  sdk ? false,
  sqlite,
  stdenv,
  systemd,
  udev,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
  writeScript,
}:

let
  bits =
    if stdenv.hostPlatform.is64bit then "x64" else throw "NW.js no longer supports 32-bit Linux.";

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      alsa-lib
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
      libcap
      libdrm
      libGL
      libnotify
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      libx11
      libxscrnsaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      libxshmfence
      # libnw-specific (not chromium dependencies)
      ffmpeg
      libxcb
      # chromium runtime deps (dlopen’d)
      libuuid
      sqlite
      udev
    ];

    extraOutputsToInstall = [
      "lib"
      "out"
    ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "nwjs";
  version = "0.111.1";

  src =
    let
      flavor = if sdk then "sdk-" else "";
    in
    fetchurl {
      url = "https://dl.nwjs.io/v${finalAttrs.version}/nwjs-${flavor}v${finalAttrs.version}-linux-${bits}.tar.gz";
      hash =
        {
          "sdk-x64" = "sha256-r1QvA7/1Kf1Jo6MabE1Ia8XGQ4kJXd0nBn7EDRE8Lig=";
          "x64" = "sha256-fH9tLe7qAM2+kfIe37zjP/wmuataMm4KSopEMRHEdf8=";
        }
        ."${flavor + bits}";
    };

  nativeBuildInputs = [
    autoPatchelfHook
    # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
    # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
    (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
  ];

  buildInputs = [ nwEnv ];
  appendRunpaths = map (pkg: (lib.getLib pkg) + "/lib") [
    nwEnv
    stdenv.cc.libc
    stdenv.cc.cc
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nwjs
    cp -R * $out/share/nwjs
    find $out/share/nwjs

    ln -s ${lib.getLib systemd}/lib/libudev.so $out/share/nwjs/libudev.so.0

    mkdir -p $out/bin
    ln -s $out/share/nwjs/nw $out/bin

    mkdir $out/lib
    ln -s $out/share/nwjs/lib/libnw.so $out/lib/libnw.so

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-nwjs" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq gnused nix

    set -euo pipefail

    # NW.js does not use GitHub releases. Fetch from their official registry.
    VERSION_TAG=$(curl -s https://nwjs.io/versions.json | jq -r .latest)
    VERSION="''${VERSION_TAG#v}"

    if [ -z "$VERSION" ] || [ "$VERSION" = "null" ]; then
        echo "Failed to fetch version from nwjs.io/versions.json" >&2
        exit 1
    fi

    FILE="pkgs/by-name/nw/nwjs/package.nix"
    if [ ! -f "$FILE" ]; then
        FILE=$(nix-instantiate --eval --strict -A nwjs.meta.position | sed -re 's/^"(.*):[0-9]+"$/\1/')
    fi

    CURRENT_VERSION=$(grep 'version = "' "$FILE" | sed -n 's/.*version = "\([^"]*\)".*/\1/p' | head -n1)

    if [[ "$VERSION" == "$CURRENT_VERSION" ]]; then
        echo "nwjs is already up to date ($VERSION)"
        exit 0
    fi

    echo "Updating nwjs from $CURRENT_VERSION to $VERSION"

    for flavor in "" "sdk-"; do
        for bits in "x64"; do
            URL="https://dl.nwjs.io/v''${VERSION}/nwjs-''${flavor}v''${VERSION}-linux-''${bits}.tar.gz"
            echo "Prefetching ''${flavor}''${bits}..."

            HASH=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "$URL" 2>/dev/null))

            # Replace the hash inline
            sed -i -e "s|\"''${flavor}''${bits}\" = \"[^\"]*\";|\"''${flavor}''${bits}\" = \"$HASH\";|" "$FILE"
        done
    done

    # Update version string
    sed -i -e "s|version = \"$CURRENT_VERSION\";|version = \"$VERSION\";|" "$FILE"

    echo "Successfully updated to $VERSION"
  '';

  meta = {
    description = "App runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.mikaelfangel ];
    mainProgram = "nw";
    license = lib.licenses.mit;
  };
})
