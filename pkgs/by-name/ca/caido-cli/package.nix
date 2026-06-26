{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  libgcc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caido-cli";
  version = "0.56.2";

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-SUkysiFdH4ilA6MKYMiSqC80NkYZ9YVO/7CT0hQY++Q=";
      };
      aarch64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-rYRzo3iYjWAvRGm1+wBLGkr3eUoAGbi71+AX0qmoIXs=";
      };
      x86_64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-x86_64.zip";
        hash = "sha256-mMWivNwgAmMYitERwnP/lAzgzua/2UDDDffSbgZXlr4=";
      };
      aarch64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-aarch64.zip";
        hash = "sha256-19eEV79yk6PCHdl7oTw4Gqt10B7rYnZCJxBebDssFZc=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "caido-cli: unsupported system ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ unzip ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libgcc ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m 755 -D caido-cli $out/bin/caido-cli
    runHook postInstall
  '';

  meta = {
    description = "Caido CLI — lightweight web security auditing toolkit";
    homepage = "https://caido.io/";
    changelog = "https://github.com/caido/caido/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    mainProgram = "caido-cli";
    maintainers = with lib.maintainers; [
      blackzeshi
      m0streng0
      octodi
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
