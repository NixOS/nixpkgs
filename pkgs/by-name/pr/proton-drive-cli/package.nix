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

  postPatch = ''
    # Upstream does not allow newer bun versions, remove when they fix it.
    substituteInPlace package.json --replace-fail '"bun": "1.' '"bun": "^1.'
    # cli/tsconfig.json compiles the SDK packages from client/js and
    # incubating/account/js, which cannot see their dependencies in the isolated
    # node_modules. Use the copies in node_modules instead.
    substituteInPlace tsconfig.json \
      --replace-fail '"../client/js/src' '"./node_modules/@protontech/drive-sdk/src' \
      --replace-fail '"../incubating/account/js/src' '"./node_modules/proton-drive-sdk-account/src'
  '';

  configurePhase = ''
    runHook preConfigure
    # Upstream takes the bundled js SDK version from the latest js/v* git tag,
    # which is not available here. Read it from the SDK changelog instead.
    JS_VERSION=$(sed -n 's|^## js/v\([0-9.]*\) .*|\1|p' ../client/js/CHANGELOG.md | head -n1)
    [[ -n $JS_VERSION ]] || { echo "Could not determine JS_VERSION" >&2; exit 1; }
    export JS_VERSION
    cp -R ${finalAttrs.passthru.nodeModules}/node_modules node_modules
    runHook postConfigure
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
      inherit (finalAttrs)
        version
        src
        sourceRoot
        strictDeps
        __structuredAttrs
        ;
      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];
      dontFixup = true; # keeps the outputHash stable
      postPatch = ''
        # Prevent hoisted fallback for undeclared deps; unused here and its layout changed between bun versions.
        printf '[install]\nhoist = false\n' >> bunfig.toml
      '';
      buildPhase = ''
        runHook preBuild
        # The isolated linker copies the "file:" dependencies instead of symlinking them by absolute path,
        # so the output does not depend on the build directory.
        bun install --force --no-progress --production \
                    --frozen-lockfile --ignore-scripts \
                    --os="*" --cpu="*" --linker=isolated
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        mv node_modules $out/
        runHook postInstall
      '';
      outputHashMode = "recursive";
      outputHash = "sha256-eRNZUYqqqy/LCQ3u4GNL6jvUjAxdnz4nwz8c1eTX6g4=";
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
    inherit (bun.meta) platforms;
    mainProgram = "proton-drive";
  };
})
