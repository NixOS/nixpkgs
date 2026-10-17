{
  autoPatchelfHook,
  fetchurl,
  lib,
  openssl,
  stdenvNoCC,
  zlib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "octobot-bin";
  version = "2.1.1";
  __structuredAttrs = true;

  src = fetchurl (
    let
      platform =
        {
          "aarch64-linux" = {
            arch = "arm64";
            hash = "sha256-nq87HxM5KRbqwJa06hax6gRsDAmHA7m7HcwTe4uR8gk=";
          };
          "x86_64-linux" = {
            arch = "x64";
            hash = "sha256-nDXWD1jzJtsFT+W8EAs3k+17s/15ZtgDbNqA2Pe2Ed4=";
          };
        }
        .${stdenvNoCC.hostPlatform.system};
    in
    {
      url = "https://github.com/Drakkar-Software/octobot/releases/download/${finalAttrs.version}/octobot_linux_${platform.arch}";
      inherit (platform) hash;
    }
  );

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [ autoPatchelfHook ];

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
    changelog = "https://github.com/Drakkar-Software/OctoBot/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Octobot is a powerful open-source cryptocurrency trading robot.";
    homepage = "https://www.octobot.cloud";
    license = lib.licenses.gpl3Plus;
    mainProgram = "octobot";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ grandjeanlab ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
