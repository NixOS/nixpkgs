{
  lib,
  stdenv,
  fetchzip,
  cpio,
  gzip,
  xar,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rode-central";
  version = "2.0.101-212";

  # archive.org link used because the url is not stable and is updated frequently with new versions
  src = fetchzip {
    url = "https://web.archive.org/web/20250730140348/https://update.rode.com/central/RODE_Central_MACOS.zip";
    hash = "sha256-qgOosVOETeIbKBUhRvp2WGaO0mWEceOjtahF0fYrZ1E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cpio
    gzip
    xar
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src/RØDE\ Central\ \(${finalAttrs.version}\).pkg
    zcat RodeCentral.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Applications/RODE\ Central.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Companion app for configuring compatible RØDE devices, unlocking advanced features, enabling or disabling functions and updating firmware";
    homepage = "https://rode.com/en-us/apps/rode-central";
    changelog = "https://rode.com/en-us/release-notes/rode-central";
    license = [ lib.licenses.unfree ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.darwin;
    hydraPlatforms = [ ];
  };
})
