{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aldente";
  version = "1.36.1";

  src = fetchurl {
    url = "https://github.com/AppHouseKitchen/AlDente-Battery_Care_and_Monitoring/releases/download/${finalAttrs.version}/AlDente.dmg";
    hash = "sha256-iouXZv6dfLGawWtDH+/wGOogDjUoqp55BE2ADAAos0o=";
  };

  dontBuild = true;
  dontFixup = true;

  # AlDente.dmg is APFS formatted, unpack with 7zz
  nativeBuildInputs = [ _7zz ];

  sourceRoot = "AlDente.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/AlDente.app
    cp -R . $out/Applications/AlDente.app

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS tool to limit maximum charging percentage";
    homepage = "https://apphousekitchen.com";
    changelog = "https://github.com/davidwernhart/aldente-charge-limiter/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
