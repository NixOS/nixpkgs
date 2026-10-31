{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  makeWrapper,
  versionCheckHook,
  glib,
  libsecret,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-drive-cli";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "ProtonDriveApps";
    repo = "sdk";
    tag = "cli/v${finalAttrs.version}";
    hash = "sha256-PzLNFh6gbCQ3XbQ6RvUyykGgUV2DM7R65pIxs5grSrY=";
  };
  sourceRoot = "${finalAttrs.src.name}/cli";

  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [ bun ] ++ lib.optional stdenvNoCC.hostPlatform.isLinux makeWrapper;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # `bun build --compile` embeds the JS bundle in the ELF.
  # Stripping removes it and leaves a binary that just runs plain `bun`.
  dontStrip = true;

  env = {
    CLI_APP_VERSION_NAME = "cli-drive-nixos";
    CLI_VERSION = finalAttrs.version;
  };

  # cli/tsconfig.json compiles the SDK packages from client/js and
  # incubating/account/js, which cannot see their dependencies in the isolated
  # node_modules. Use the copies in node_modules instead, like for crypto.
  postPatch = ''
    substituteInPlace tsconfig.json \
      --replace-fail '"../client/js/src' '"./node_modules/@protontech/drive-sdk/src' \
      --replace-fail '"../incubating/account/js/src' '"./node_modules/proton-drive-sdk-account/src'
  '';

  configurePhase = ''
    runHook preConfigure
    cp -R ${finalAttrs.passthru.nodeModules}/node_modules node_modules
    runHook postConfigure
  '';

  # Upstream takes the bundled js SDK version from the latest js/v* git tag,
  # which is not available here. Read it from the SDK changelog instead.
  preBuild = ''
    JS_VERSION=$(sed -n 's|^## js/v\([0-9.]*\) .*|\1|p' ../client/js/CHANGELOG.md | head -n1)
    [[ -n $JS_VERSION ]] || { echo "Could not determine JS_VERSION" >&2; exit 1; }
    export JS_VERSION
  '';

  buildPhase = ''
    runHook preBuild
    bun run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 release/proton-drive $out/bin/proton-drive
    runHook postInstall
  '';

  postInstall = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    wrapProgram $out/bin/proton-drive --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        glib
        libsecret
      ]
    }
  '';

  passthru = {
    nodeModules = stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node-modules";
      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs.src.name}/cli";
      strictDeps = true;
      __structuredAttrs = true;
      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];
      dontConfigure = true;
      dontFixup = true; # keeps the outputHash stable
      buildPhase = ''
        runHook preBuild
        # The isolated linker copies the file: dependencies (client/js,
        # incubating/account/js) instead of symlinking them by absolute path,
        # so the output does not depend on the build directory.
        bun install --force --no-progress --production \
                    --frozen-lockfile --ignore-scripts \
                    --os="*" --cpu="*" --linker=isolated
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R node_modules $out/
        runHook postInstall
      '';
      outputHashMode = "recursive";
      outputHash = "sha256-0Rxuf8+gG1KzrWrmhH669p/OnG15WjGV//QWLcCE7V8=";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=cli/v(.*)"
        "--custom-dep=nodeModules"
      ];
    };
  };

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
