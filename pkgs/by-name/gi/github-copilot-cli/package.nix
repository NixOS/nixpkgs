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
    with stdenv.hostPlatform;
    if isx86_64 then
      "x64"
    else if isAarch64 then
      "arm64"
    else
      throw "Unsupported arch: ${stdenv.hostPlatform.system}";
  platform = if stdenv.hostPlatform.isDarwin then "darwin-${arch}" else "linux-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-cli";
  version = "1.0.65";

  src = fetchurl {
    url = "https://github.com/github/copilot-cli/releases/download/v${finalAttrs.version}/github-copilot-${finalAttrs.version}-${platform}.tgz";
    hash =
      {
        "x86_64-darwin" = "sha256-D72R1Vt/6eSg7INVYjPtC5W/6oPVzpVC1Tn4q831Wqs=";
        "aarch64-darwin" = "sha256-Ly/Tay3iOMzsipaWLTTh3HKBYwvq7Nu3yQpYrC39UPI=";
        "x86_64-linux" = "sha256-E8vo0HUyvw9U7cXbjeY7H9atxdMHHLMXcGgWEciuqK0=";
        "aarch64-linux" = "sha256-3l260k1Uw79owiBP2bhNfGgqkE35JN7zPSb8OXIpeuI=";
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
    maintainers = with lib.maintainers; [
      dbreyfogle
      me-and
    ];
    mainProgram = "copilot";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
