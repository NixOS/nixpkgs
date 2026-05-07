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
  version = "0.55.3";

  src = fetchurl (
    {
      x86_64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-ys5gMO0jGy5d8ncwQo9ES0gn7Ddckf3496CAyGgKEus=";
      };
      aarch64-linux = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-JvWktRnNyzu98NeSOFJ6nhF60uQfSL6ys5BmTkYuwCQ=";
      };
      x86_64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-x86_64.zip";
        hash = "sha256-bnFGa8GMDTdCjk9xJL9rGvZ1H6MMzzXrlWXGRlE5XPg=";
      };
      aarch64-darwin = {
        url = "https://caido.download/releases/v${finalAttrs.version}/caido-cli-v${finalAttrs.version}-mac-aarch64.zip";
        hash = "sha256-UVBQKkGsYJ84cthFkCXrHI85t8LJPy4z5sP5TobVNeA=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "caido-cli: unsupported system ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs =
    lib.optionals stdenv.isLinux [ autoPatchelfHook ] ++ lib.optionals stdenv.isDarwin [ unzip ];

  buildInputs = lib.optionals stdenv.isLinux [ libgcc ];

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
