{
  lib,
  fetchurl,
  undmg,
  stdenvNoCC,
}:
let
  releaseUrl = "https://github.com/BlueBubblesApp/bluebubbles-server/releases/download";
in
stdenvNoCC.mkDerivation rec {
  pname = "bluebubbles-server";
  version = "1.9.9";

  src =
    fetchurl
      {
        x86_64-darwin = {
          url = "${releaseUrl}/v${version}/BlueBubbles-${version}.dmg";
          hash = "sha256-loHmX2AhSmqV870StXvUzIrW2PWM2cHYgRsqRgatfAQ=";
        };
        aarch64-darwin = {
          url = "${releaseUrl}/v${version}/BlueBubbles-${version}-arm64.dmg";
          hash = "sha256-+v1lDIg/UudJSmYl5FJJ8hRNGXN4pNVxQ8z2GYuy6GI=";
        };
      }
      .${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  nativeBuildInputs = [ undmg ];

  sourceRoot = "BlueBubbles.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/BlueBubbles.app
    cp -R . $out/Applications/BlueBubbles.app

    runHook postInstall
  '';

  meta = {
    description = "Server for the BlueBubbles messaging app";
    homepage = "https://github.com/BlueBubblesApp/bluebubbles-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zacharyweiss ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
