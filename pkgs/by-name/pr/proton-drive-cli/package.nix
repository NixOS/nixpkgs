{
  lib,
  stdenvNoCC,
  bun,
  nodejs,
  fetchFromGitHub,
  glib,
  libffi,
  libgcrypt,
  libgpg-error,
  libsecret,
  libselinux,
  makeWrapper,
  pcre2,
  util-linux,
  writableTmpDirAsHomeHook,
  xdg-utils,
}:
let
  secretsLibs = [
    libsecret
    glib
    pcre2
    libffi
    libselinux
    libgpg-error
    util-linux.lib
    libgcrypt.lib
  ];
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.8.0-unstable-2026-09-13";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    rev = "5491f2eea473acaaa86b5969774b84610a37bd46";
    hash = "sha256-JLyl5I3t5297LEB7ka8RUNwU0BnYy5jeLp3mywoV/YE=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src sourceRoot;

    strictDeps = true;
    __structuredAttrs = true;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      # Bun does not install optional dependencies from local file dependencies.
      chmod -R u+w ../client/js
      pushd ../client/js
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*" \
        --production
      popd

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out/
      mkdir $out/client
      cp -R ../client/js/node_modules/@xmldom $out/client/
      cp -R ../client/js/node_modules/exifreader $out/client/

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-5CzqA3FEt/6sXwVfXH3v8Od3xkSyCRdsxOsvBnGORCg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    makeWrapper
  ];
  buildInputs = secretsLibs;

  configurePhase = ''
    runHook preConfigure

    # Upstream uses a sibling package dependency via `file:../client/js`.
    chmod -R u+w ../client/js ../incubating/account/js
    cp -R ${finalAttrs.node_modules}/node_modules .
    cp -R ${finalAttrs.node_modules}/node_modules ../client/js/
    cp -R ${finalAttrs.node_modules}/node_modules ../incubating/account/js/
    chmod u+w ../client/js/node_modules
    cp -R ${finalAttrs.node_modules}/client/. ../client/js/node_modules/

    substituteInPlace ../client/js/node_modules/.bin/tsc \
      --replace-fail '#!/usr/bin/env node' '#!${lib.getExe nodejs}'

    runHook postConfigure
  '';

  # Proton validates the embedded CLI version during auth; nixpkgs-style
  # unstable versions trigger a 400 on /auth/v4/sessions/forks, so keep the
  # upstream runtime version format here.
  env.CLI_VERSION = "${builtins.head (lib.splitString "-" finalAttrs.version)}+${
    builtins.substring 0 7 finalAttrs.src.rev
  }";
  env.JS_VERSION = "0.19.2+${builtins.substring 0 7 finalAttrs.src.rev}";
  env.CLI_APP_VERSION_NAME = "cli-drive-nixos";

  buildPhase = ''
    runHook preBuild

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 release/proton-drive $out/bin/proton-drive
    wrapProgram $out/bin/proton-drive \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath secretsLibs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    runHook postInstall
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    PROTON_DRIVE_CREDENTIALS_STORE=unsafe_file $out/bin/proton-drive version > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    description = "Command-line interface for Proton Drive";
    homepage = "https://github.com/ProtonDriveApps/sdk/tree/${finalAttrs.src.rev}/cli";
    changelog = "https://github.com/ProtonDriveApps/sdk/blob/${finalAttrs.src.rev}/cli/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cameroncandau ];
    mainProgram = "proton-drive";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
