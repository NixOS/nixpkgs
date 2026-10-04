{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  bun,
  libsecret,
  glib,
}:
let
  # Latest js/v* tag contained in the cli release, see update.sh.
  jsVersion = "0.21.0";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.8.0";
  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-JLyl5I3t5297LEB7ka8RUNwU0BnYy5jeLp3mywoV/YE=";
  };

  passthru.nodeModules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node-modules";
    inherit (finalAttrs) version src;
    # client/js declares @xmldom/xmldom and exifreader as optionalDependencies,
    # but the upstream cli/bun.lock is stale and lacks them, so
    # `bun install --frozen-lockfile` silently skips them. This adds them to
    # the @protontech/drive-sdk lockfile entry.
    # Fixed upstream on main, remove with the next cli release.
    patches = [ ./additional-deps.patch ];
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    dontFixup = true; # keeps the outputHash stable and prevents broken symlinks errors
    buildPhase = ''
      runHook preBuild
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d) # keeps the outputHash stable
      cd cli
      bun install --force --frozen-lockfile --ignore-scripts --no-progress --production
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R node_modules $out/
      runHook postInstall
    '';
    outputHashMode = "recursive";
    outputHash =
      if stdenvNoCC.hostPlatform.isLinux then
        "sha256-IoATZ6cZKDecg0WRSaHM3OrKWF1snV4qVNXp0ODktsg="
      else if stdenvNoCC.hostPlatform.isDarwin then
        "sha256-4vyENUcqbXiJAMZvROKxlT2KBYVC9MUfE9EtTewrsCY="
      else
        throw "${finalAttrs.pname}: unsupported platform ${stdenvNoCC.hostPlatform.system}";
  };

  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = ./update.sh;

  # `bun build --compile` embeds the JS bundle in the ELF.
  # Stripping removes it and leaves a binary that just runs plain `bun`.
  dontStrip = true;

  env = {
    CLI_APP_VERSION_NAME = "cli-drive-nixos";
    CLI_VERSION = "${finalAttrs.version}";
    JS_VERSION = "${jsVersion}";
  };

  configurePhase = ''
    runHook preConfigure
    cp -R ${finalAttrs.passthru.nodeModules}/node_modules cli/node_modules
    # cli/tsconfig.json maps the SDK packages to their sources in client/js and
    # incubating/account/js, whose imports resolve node_modules from there upwards.
    ln -s cli/node_modules node_modules
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd cli
    bun run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 release/proton-drive $out/bin/proton-drive
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    wrapProgram $out/bin/proton-drive \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libsecret
          glib
        ]
      }
  '';

  meta = {
    description = "Proton Drive command-line interface";
    homepage = "https://github.com/ProtonDriveApps/sdk/tree/main/cli";
    changelog = "https://github.com/ProtonDriveApps/sdk/blob/main/cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.linusemr618
      lib.maintainers.utopiatopia
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "proton-drive";
  };
})
