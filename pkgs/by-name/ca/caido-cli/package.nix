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
  version = "0.57.0";

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-ujpGYERNceUPartkgx4o38xUfPwWvnmiEnjkvmEbybA=";
      };
      aarch64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-d1xzF0N6emShCQpotFiQEj1wV3hdt1DK7R+6Smlxrmg=";
      };
      x86_64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-x86_64.zip";
        hash = "sha256-xh6kaYPJ7dwDHM1CkDzxYBHM4cKUex+XPXceqvQgWX4=";
      };
      aarch64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-aarch64.zip";
        hash = "sha256-FwbKLEwjiFzZWdBS6RgsDtc/EkI9AT2CBGwdmgEdDnw=";
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
