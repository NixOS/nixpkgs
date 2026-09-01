{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  pbzx,
  cpio,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sing-box-for-apple";
  version = "1.14.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/SagerNet/sing-box/releases/download/v${finalAttrs.version}/SFM-${finalAttrs.version}-Apple.pkg";
    hash = "sha256-aP3lMwbzKqzS1NDvDy6grib4JgHGLDiatT3BVPtUqUw=";
  };

  dontUnpack = true;
  strictDeps = true;

  nativeBuildInputs = [
    xar
    pbzx
    cpio
  ];

  installPhase = ''
    runHook preInstall

    mkdir extracted
    cd extracted
    xar -xf "$src"

    mkdir -p \
      "$out/Applications" \
      "$out/bin" \
      "$out/share/licenses/sing-box-for-apple" \
      "$out/share/sing-box-for-apple"

    cd "$out/Applications"
    pbzx -n "$NIX_BUILD_TOP/extracted/component-arm64.pkg/Payload" \
      | cpio -idm --no-absolute-filenames

    ln -s "$out/Applications/SFM.app/Contents/MacOS/SFM" \
      "$out/bin/sing-box"
    ln -s "$src" "$out/share/sing-box-for-apple/SFM.pkg"
    install -Dm644 "$NIX_BUILD_TOP/extracted/Resources/LICENSE" \
      "$out/share/licenses/sing-box-for-apple/LICENSE"

    runHook postInstall
  '';

  # Rewriting Mach-O files would invalidate upstream's signatures. The app,
  # system extension, and privileged helper must remain byte-for-byte intact.
  dontFixup = true;

  passthru = {
    installer = finalAttrs.src;
    sourceRevision = "59540eb0e1812bb76a481a9dc3dec6a788f4196f";
  };

  meta = {
    description = "macOS client for the sing-box universal proxy platform";
    homepage = "https://github.com/SagerNet/sing-box-for-apple";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ snemeow ];
    mainProgram = "sing-box";
    platforms = [ "aarch64-darwin" ];
  };
})
