{
  alsa-lib,
  atk,
  autoPatchelfHook,
  bubblewrap,
  cairo,
  dpkg,
  fetchurl,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  lcms,
  lib,
  libglvnd,
  libjack2,
  libjpeg8,
  libnghttp2,
  libudev-zero,
  libx11,
  libxcb,
  libxcb-util,
  libxcb-wm,
  libxcursor,
  libxkbcommon,
  libxtst,
  makeBinaryWrapper,
  pango,
  pipewire,
  stdenv,
  vulkan-loader,
  wrapGAppsHook3,
  writeScript,
  writeShellScript,
  xcb-imdkit,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwig-studio6";
  version = "6.1.4";

  src = fetchurl {
    name = "bitwig-studio-${finalAttrs.version}.deb";
    url = "https://www.bitwig.com/dl/Bitwig%20Studio/${finalAttrs.version}/installer_linux";
    hash = "sha256-+tfRNwaXlyPTw+yvUJ2Bz7tJw5qWv/Xqsrx16u8QgXU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    lcms
    libglvnd
    (lib.getLib stdenv.cc.cc)
    libjack2
    libjpeg8
    libnghttp2
    libudev-zero
    libx11
    libxcb
    libxcb-util
    libxcb-wm
    libxcursor
    libxkbcommon
    libxtst
    pango
    pipewire
    vulkan-loader
    xcb-imdkit
    zlib
    alsa-lib
  ];

  dontWrapGApps = true; # we only want $gappsWrapperArgs here

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    cp -r usr/share "$out"
    cp -r opt/bitwig-studio "$out"/libexec

    # Bitwig includes a copy of libxcb-imdkit.
    # Removing it will force it to use our version.
    rm "$out"/libexec/lib/bitwig-studio/libxcb-imdkit.so.1

    runHook postInstall
  '';

  postFixup =
    let
      wrapper = writeShellScript "bitwig-studio" ''
        set -e

        currentDir="$(cd "$(dirname "$0")" && pwd)"
        outDir="$(cd "$currentDir/.." && pwd)"

        TMPDIR="$(mktemp --directory)"
        cp -r "$outDir"/libexec/resources/VampTransforms "$TMPDIR"
        chmod -R u+w "$TMPDIR/VampTransforms"

        bwrap \
          --bind / / \
          --bind "$TMPDIR"/VampTransforms "$outDir"/libexec/resources/VampTransforms \
          --dev-bind /dev /dev \
          "$outDir"/libexec/bitwig-studio \
          || true

        rm -rf "$TMPDIR"
      '';
    in
    ''
      for e in "$out"/libexec/bin/*gtk*; do
        if [ -f "$e" ] && [ -x "$e" ]; then
          wrapProgram "$e" "''${gappsWrapperArgs[@]}"
        fi
      done

      install -D ${wrapper} "$out"/bin/bitwig-studio
      wrapProgram "$out"/bin/bitwig-studio \
        --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
    '';

  passthru.updateScript =
    let
      currentMajorVersion = lib.versions.major finalAttrs.version;
      nextMajorVersion = toString (lib.toInt currentMajorVersion + 1);
    in
    writeScript "update-bitwig-studio" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl common-updater-scripts

      set -euo pipefail

      bitwig_studio_version=$(curl -Ls https://bitwig.com/download | grep -oE '/[^/a-zA-Z][0-9.]+/' | head -n1 | tr -d '/')

      if [[ ''${bitwig_studio_version/.*/} -gt ${currentMajorVersion} ]]; then
        echo "Bitwig Studio ${currentMajorVersion} has stopped receiving updates due to ${nextMajorVersion} being out." >&2
        echo "The latest version is: $bitwig_studio_version" >&2
        exit 1
      fi

      pkg_hash=$(nix-prefetch-url https://bitwig.com/dl/Bitwig%20Studio/"$bitwig_studio_version"/installer_linux)
      pkg_hash=$(nix --extra-experimental-features nix-command hash convert "sha256:$pkg_hash")
      update-source-version bitwig-studio6 "$bitwig_studio_version" "$pkg_hash" --system=x86_64-linux --ignore-same-version
    '';

  meta = {
    description = "Digital audio workstation";
    longDescription = ''
      Bitwig Studio is a multi-platform music-creation system for
      production, performance and DJing, with a focus on flexible
      editing tools and a super-fast workflow.
    '';
    homepage = "https://www.bitwig.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      bfortz
      eleina
      michalrus
      mrVanDalo
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "bitwig-studio";
  };
})
