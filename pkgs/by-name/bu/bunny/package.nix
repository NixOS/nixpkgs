{
  bun,
  lib,
  fetchFromGitHub,
  nodejs,
  stdenv,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bunny";
  version = "0.21.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BunnyWay";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+AvtyONO8/TDDzSUHfBxIDj+vanP0FNsRBp+2tvUdII=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-node_modules";

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --no-progress --frozen-lockfile --no-cache

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      {
        x86_64-linux = "sha256-KvLlAVwL1tvt0vsW7QIaZKDmUkw3ejbo3zN9qmT6ou8=";
        aarch64-linux = "sha256-ojB0CwU1vyuewNXeC+g9y8O90EjeAFfnbfhRcSskSsE=";
        aarch64-darwin = "sha256-p8zVVP2AFpCU0xzxEzixCsKPDddMaqTeoW0yTG2iWw8=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    nodejs
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bunny $out/bin/bunny
    runHook postInstall
  '';
  dontStrip = true;

  passthru.updateScript = nix-update-script { };
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command-line interface for bunny.net — manage databases, static sites, apps (Magic Containers), Edge Scripts, and more from your terminal.";
    homepage = "https://github.com/BunnyWay/cli";
    changelog = "https://github.com/BunnyWay/cli/blob/${finalAttrs.src.rev}/packages/cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      asleepyskye
    ];
    mainProgram = "bunny";
  };
})
