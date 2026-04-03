{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  zlib,
  openssl,
}:
let
  archConfig =
    if stdenv.hostPlatform.isAarch64 then
      {
        arch = "arm64";
        sha256 = "02gjj65pn4yc3nxvj0w71466q17an4bfmd4nq3m1ca9r2cgkpbwy";
      }
    else if stdenv.hostPlatform.isx86_64 then
      {
        arch = "x64";
        sha256 = "nDXWD1jzJtsFT+W8EAs3k+17s/15ZtgDbNqA2Pe2Ed4=";
      }
    else
      throw "Unsupported architecture: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "octobot-bin";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/Drakkar-Software/octobot/releases/download/${finalAttrs.version}/octobot_linux_${archConfig.arch}";
    inherit (archConfig) sha256;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/bin/${finalAttrs.meta.mainProgram}
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Drakkar-Software/OctoBot/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Octobot is a powerful open-source cryptocurrency trading robot.";
    homepage = "https://www.octobot.cloud";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ grandjeanlab ];
    mainProgram = "octobot-bin";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
