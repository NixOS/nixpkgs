{
  lib,
  stdenv,
  fetchurl,
  squashfsTools,
  makeWrapper,
  imagemagick,
  electron,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "singularityapp";
  version = "12.4.1";
  revision = "141";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/MGxJGb96XBV8UshTS2iqLOI4ylXW8xwY_${finalAttrs.revision}.snap";
    hash = "sha512-vKisK0y2pSxjwiGzfKkE/HxN0CaN6YIxynW8vYPBns1Z8mU9Ki9MYtgsh/oTzCW7KEM8GAMqjEU68x5ALGL+wQ==";
  };

  nativeBuildInputs = [
    squashfsTools
    makeWrapper
    imagemagick
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    unsquashfs -dest squashfs-root "$src"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/singularityapp"
    cp -r squashfs-root/resources/app.asar squashfs-root/resources/app.asar.unpacked \
      "$out/share/singularityapp/"

    install -Dm644 squashfs-root/meta/gui/singularityapp.desktop \
      "$out/share/applications/singularityapp.desktop"
    substituteInPlace "$out/share/applications/singularityapp.desktop" \
      --replace-fail 'Icon=''${SNAP}/meta/gui/icon.png' 'Icon=singularityapp'

    # hicolor only indexes sizes up to 512x512; downscale the 1024px source.
    for size in 16 32 48 64 128 256 512; do
      dir="$out/share/icons/hicolor/''${size}x''${size}/apps"
      mkdir -p "$dir"
      magick squashfs-root/meta/gui/icon.png -resize "''${size}x''${size}" "$dir/singularityapp.png"
    done

    makeWrapper ${lib.getExe electron} "$out/bin/singularityapp" \
      --add-flags "$out/share/singularityapp/app.asar" \
      --set-default ELECTRON_OZONE_PLATFORM_HINT auto

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "All-in-one productivity app: to-do list, calendar, planner, notepad, and habit tracker";
    homepage = "https://singularity-app.com/";
    downloadPage = "https://snapcraft.io/singularityapp";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ qweered ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "singularityapp";
  };
})
