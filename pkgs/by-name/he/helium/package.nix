{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "helium";
  version = "0.4.6.1";

  src =
    {
      aarch64-darwin = fetchurl {
        name = "helium_0.4.6.1_arm64-macos.dmg";
        url = "https://github.com/imputnet/helium-macos/releases/download/0.4.6.1/helium_${finalAttrs.version}_arm64-macos.dmg";
        hash = "sha256-K9fnxc5sDAiDj008IzwLI4BBI5mrfz3FpuECF2s+5pw=";
      };
      x86_64-darwin = fetchurl {
        name = "helium_0.4.6.1_x86_64-macos.dmg";
        url = "https://github.com/imputnet/helium-macos/releases/download/0.4.6.1/helium_${finalAttrs.version}_x86_64-macos.dmg";
        hash = "sha256-VjhIMQBnagSQArmsF77bO2PwYZWzGOagBL134bUW6e4=";
      };
    }
    .${stdenvNoCC.system} or (throw "helium: ${stdenvNoCC.system} is unsupported.");

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Helium.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Helium.app
    cp -R . $out/Applications/Helium.app

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://helium.computer/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      lalit64
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
