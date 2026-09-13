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
  jsVersion = "0.21.0"; # tag js/v${jsVersion}; CHANGEME for updates
  commitHash = "5491f2e"; # short hash of tag cli/v${version}; CHANGEME for updates
  bunAddPkgs = "'@xmldom/xmldom@^0.9.10' 'exifreader@^4.39.1'"; # optionalDependencies in client/js/package.json; CHANGEME for updates
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.8.0"; # tag cli/v${version}; CHANGEME for updates

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
      bun install --force --frozen-lockfile --ignore-scripts --no-progress --production
      bun add --force --no-save --ignore-scripts --no-progress --omit=dev ${bunAddPkgs}
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R node_modules $out/
      runHook postInstall
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-82OihPTmvR895ume/hyMl8EewWj3gySKvGVTpiLetsg=";
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
    cp -R ${finalAttrs.passthru.nodeModules}/node_modules cli/node_modules
    ln -s "$PWD/cli/node_modules" client/js/node_modules
    ln -s "$PWD/cli/node_modules" incubating/account/js/node_modules
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
