{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "helium";
  version = "0.4.6.1";

  src =
    let
      inherit (finalAttrs) version;
    in
    {
      aarch64-darwin = fetchurl {
        name = "helium_${version}_arm64-macos.dmg";
        url = "https://github.com/imputnet/helium-macos/releases/download/${version}/helium_${version}_arm64-macos.dmg";
        hash = "sha256-K9fnxc5sDAiDj008IzwLI4BBI5mrfz3FpuECF2s+5pw=";
      };
      x86_64-darwin = fetchurl {
        name = "helium_${version}_x86_64-macos.dmg";
        url = "https://github.com/imputnet/helium-macos/releases/download/${version}/helium_${version}_x86_64-macos.dmg";
        hash = "sha256-VjhIMQBnagSQArmsF77bO2PwYZWzGOagBL134bUW6e4=";
      };
    }
    .${stdenvNoCC.system} or (throw "helium: ${stdenvNoCC.system} is unsupported.");

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Helium.app
    cp -R . $out/Applications/Helium.app

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://helium.computer/";
    mainProgram = "Helium.app";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      lalit64
    ];
    platforms = lib.platforms.darwin;
  };
})
