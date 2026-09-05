{
  lib,
  stdenv,
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
  # visit https://github.com/ProtonDriveApps/sdk/tags to find the versions and hashes
  jsVersion = "0.21.0"; # tag js/v${jsVersion}; change for updates
  commitHash = "5491f2e"; # short hash of tag cli/v${version}; change for updates
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.8.0"; # tag cli/v${version}; change for updates

  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-JLyl5I3t5297LEB7ka8RUNwU0BnYy5jeLp3mywoV/YE=";
  };

  passthru.nodeModules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node-modules";
    inherit (finalAttrs) version src;
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
      bun install --frozen-lockfile --ignore-scripts --no-progress --production
      cd ../client/js
      bun install --frozen-lockfile --ignore-scripts --no-progress --production
      cd ../../incubating/account/js
      bun install --frozen-lockfile --ignore-scripts --no-progress --production
      cd ../../../
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/cli $out/client/js $out/incubating/account/js
      cp -R cli/node_modules $out/cli/
      cp -R client/js/node_modules $out/client/js/
      cp -R incubating/account/js/node_modules $out/incubating/account/js/
      runHook postInstall
    '';
    outputHashMode = "recursive";
    outputHash =
      {
        x86_64-linux = "sha256-E6xm0awu5KGH3DTQX/f4jfTKGYXdsseiTz8qU0z+o34=";
        aarch64-linux = "sha256-Yan1GBe8qZmzp0OB0Bsxlm1r1bnc1WcbnK0SLWMaS9E=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Unsupported platform ${stdenv.hostPlatform.system}");
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # `bun build --compile` embeds the JS bundle in the ELF.
  # Stripping removes it and leaves a binary that just runs plain `bun`.
  dontStrip = true;
  doInstallCheck = true;

  configurePhase = ''
    runHook preConfigure
    cp -R ${finalAttrs.passthru.nodeModules}/cli/node_modules cli/
    cp -R ${finalAttrs.passthru.nodeModules}/client/js/node_modules client/js/
    cp -R ${finalAttrs.passthru.nodeModules}/incubating/account/js/node_modules incubating/account/js
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    cd cli
    bun build \
      --compile \
      --bytecode \
      --target=bun \
      --format=esm \
      --minify \
      --sourcemap=inline \
      --define "APP_VERSION=\"external-drive-sdkclijs@${finalAttrs.version}+${commitHash}\"" \
      --define "SDK_VERSION=\"js@${jsVersion}+${commitHash}\"" \
      --define SENTRY_DSN=undefined \
      src/proton-drive.ts \
      --outfile=release/proton-drive
    cd ..
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 cli/release/proton-drive $out/bin/proton-drive
    runHook postInstall
  '';

  postFixup = ''
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
    maintainers = [ lib.maintainers.linusemr618 ];
    platforms = lib.platforms.linux;
    mainProgram = "proton-drive";
  };
})
