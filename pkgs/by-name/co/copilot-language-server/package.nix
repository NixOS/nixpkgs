{
  lib,
  stdenvNoCC,
  makeWrapper,
  fetchzip,
  nix-update-script,
  nodejs-slim,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
let
  inherit (stdenvNoCC.hostPlatform.node) arch platform;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "copilot-language-server";
  version = "1.530.0";

  src = fetchzip {
    url = "https://github.com/github/copilot-language-server-release/releases/download/${finalAttrs.version}/copilot-language-server-js-${finalAttrs.version}.zip";
    hash = "sha256-dnlkzbJpoQHm7ua1wEBu9FWorrbzLK97ezM0hX/EN2Q=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    nodejs-slim
  ];

  installPhase = ''
    runHook preInstall

    server=$out/share/copilot-language-server

    mkdir -p $server
    cp -r ./* $server/

    find "$server/node_modules/@github" -mindepth 1 -maxdepth 1 \
      \( -name 'copilot-linux-*' -o -name 'copilot-darwin-*' -o -name 'copilot-win32-*' \) \
      ! -name "copilot-${platform}-${arch}" -exec rm -rf {} +

    find "$server/bin" "$server/compiled" -mindepth 1 -maxdepth 1 ! -name "${platform}" -exec rm -rf {} +
    find "$server/bin/${platform}" "$server/compiled/${platform}" -mindepth 1 -maxdepth 1 ! -name "${arch}" -exec rm -rf {} +

    find "$server/policy-templates" -mindepth 1 -maxdepth 1 ! -name "${platform}" -exec rm -rf {} +

    find "$server" -name '*.map' -delete

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/copilot-language-server \
      --add-flags $out/share/copilot-language-server/main.js

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  # uv_os_homedir returned ENOENT (no such file or directory)
  versionCheckKeepEnvironment = lib.optionals stdenvNoCC.hostPlatform.isDarwin [ "HOME" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Use GitHub Copilot with any editor or IDE via the Language Server Protocol";
    homepage = "https://github.com/features/copilot";
    license = {
      deprecated = false;
      free = false;
      fullName = "GitHub Copilot Product Specific Terms";
      redistributable = false;
      shortName = "GitHub Copilot License";
      url = "https://github.com/customer-terms/github-copilot-product-specific-terms";
    };
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # prebuild directory
      binaryBytecode # WASM files
      obfuscatedCode # minified JavaScript
    ];
    mainProgram = "copilot-language-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      arunoruto
      wattmto
    ];
  };
})
