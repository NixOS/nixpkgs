{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aldente";
  version = "1.28.2";

  src = fetchurl {
    url = "https://github.com/davidwernhart/aldente-charge-limiter/releases/download/${finalAttrs.version}/AlDente.dmg";
    hash = "sha256-CgBH5PRlq6USfdE8ubHKAYNq1YzUmfIN7wAS4HfJvZU=";
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
