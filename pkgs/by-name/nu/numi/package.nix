{
  lib,
  stdenv,
  fetchurl,
  undmg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numi";
  version = "3.32.721";

  src = fetchurl {
    url = "https://s3.numi.app/updates/${finalAttrs.version}/Numi.dmg";
    hash = "sha256-IbX4nsrPqwOSlYdNJLeaRQwIDVJrzfMXFqRqixHd2zA=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R *.app "$out/Applications"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beautiful calculator app for macOS";
    homepage = "https://numi.app/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
