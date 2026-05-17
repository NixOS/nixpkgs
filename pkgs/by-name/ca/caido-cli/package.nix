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
  version = "0.56.0";

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-G8E/GtVYzTM5JIkNnQm3PxzfZya3hVJlzUxN3s4CEdM=";
      };
      aarch64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-X+jDesBDXOWSQBTPA1kCaGBRvoaDGCR0TkNWNqYtNok=";
      };
      x86_64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-x86_64.zip";
        hash = "sha256-6Rnybe9kH65C4PHg7j9Rwz2TMjH1XPGnI1mu0/g0up8=";
      };
      aarch64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-aarch64.zip";
        hash = "sha256-07huWaIC1wO7RxC2F8VhgqKvtXcrNxbWDKFhuZhv/E8=";
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
