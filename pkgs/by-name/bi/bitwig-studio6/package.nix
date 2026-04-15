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
  writeShellScript,
  xcb-imdkit,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwig-studio6";
  version = "6.0";

  src = fetchurl {
    name = "bitwig-studio-${finalAttrs.version}.deb";
    url = "https://www.bitwig.com/dl/Bitwig%20Studio/${finalAttrs.version}/installer_linux";
    hash = "sha256-jrCTgaxfeWhfKwLeKLmqTQWS7RVbVnHqJ0InCipmm8k=";
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
