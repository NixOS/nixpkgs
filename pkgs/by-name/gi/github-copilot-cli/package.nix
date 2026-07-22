{
  lib,
  stdenv,
  autoPatchelfHook,
  cacert,
  fetchurl,
  glib,
  libsecret,
  makeBinaryWrapper,
  bash,
  nodejs,
  versionCheckHook,
}:
let
  arch =
    if stdenv.hostPlatform.isx86_64 then
      "x64"
    else if stdenv.hostPlatform.isAarch64 then
      "arm64"
    else
      throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform = if stdenv.hostPlatform.isDarwin then "darwin-${arch}" else "linux-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-cli";
  version = "1.0.73";

  src = fetchurl {
    url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}-${platform}.tgz";
    hash =
      {
        "aarch64-darwin" = "sha256-Uua3Zl+Q+Dw64qlU8b9OPlF0dba4Ej1y2fqYRG622gg=";
        "x86_64-linux" = "sha256-Bh2PVfVXYCoLmU7p8FNnAXRiFAXwTfuyqilIaaSw8cE=";
        "aarch64-linux" = "sha256-EOOiFueqIcAEknmWCtSUiox8Sin862icvr5X6Nmsmbw=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    glib
    libsecret
  ];
  sourceRoot = "package";
  dontStrip = true;
  # computer.node requires GUI/media libraries (X11, pipewire, libei, libjpeg,
  # libpng) for screen-capture and input-simulation features that are not
  # relevant for CLI use; ignore those missing deps rather than fail the build
  # or pull in heavy dependencies.
  autoPatchelfIgnoreMissingDeps = [
    "libX11.so.6"
    "libXtst.so.6"
    "libjpeg.so.8"
    "libpng16.so.16"
    "libpipewire-0.3.so.0"
    "libei.so.1"
    "libwebkit2gtk-4.1.so.0"
    "libjavascriptcoregtk-4.1.so.0"
    "libgtk-3.so.0"
    "libgdk-3.so.0"
    "libcairo.so.2"
    "libgdk_pixbuf-2.0.so.0"
    "libsoup-3.0.so.0"
    "libwayland-client.so.0"
    "libdbus-1.so.3"
    "libxdo.so.3"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"/lib/github-copilot-cli
    cp -r * "$out"/lib/github-copilot-cli
    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node "$out"/bin/copilot \
      --add-flag "$out"/lib/github-copilot-cli/index.js \
      --add-flag --no-auto-update \
      --set-default NODE_NO_WARNINGS 1 \
      --set-default SSL_CERT_DIR ${cacert}/etc/ssl/certs \
      --prefix PATH : "${lib.makeBinPath [ bash ]}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GitHub Copilot CLI brings the power of Copilot coding agent directly to your terminal";
    homepage = "https://github.com/github/copilot-cli";
    changelog = "https://github.com/github/copilot-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # including contents of the prebuild directory
      binaryBytecode # including WASM files
      obfuscatedCode # including minified JavaScript
    ];
    maintainers = with lib.maintainers; [
      me-and
    ];
    mainProgram = "copilot";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
