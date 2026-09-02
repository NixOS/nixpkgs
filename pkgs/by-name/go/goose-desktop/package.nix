{
  lib,
  stdenv,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_24,
  pnpm_10,
  electron_43,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  gitMinimal,
  python3,
  zip,
  bash,
  coreutils,
  curl,
  gnused,
  gzip,
  which,
  xdotool,
  wmctrl,
  xclip,
  xwininfo,
  wtype,
  wl-clipboard,
  goose-cli,
  runCommand,
}:

let
  nodejs = nodejs_24;
  pnpm = pnpm_10.override { nodejs-slim = nodejs; };
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "goose-desktop";
  inherit (goose-cli) version;
  __structuredAttrs = true;
  src = "${goose-cli.src}/ui";

  pnpmWorkspaces = [
    "@aaif/goose-binary-linux-x64"
    "@aaif/goose-sdk"
    "goose-app"
  ];
  # Keep the fixed-output dependency fetch scoped to the only supported desktop platform.
  pnpmInstallFlags = [
    "--cpu=x64"
    "--libc=glibc"
    "--os=linux"
  ];
  prePnpmInstall = ''
    pnpm config set --json supportedArchitectures '{"os":["linux"],"cpu":["x64"],"libc":["glibc"]}'
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      prePnpmInstall
      version
      src
      pnpmInstallFlags
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-suVaAsK8bzsb2nNbvlhb/lMjs3Q2fiKRo3TSpome6tI=";
  };

  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    copyDesktopItems
    gitMinimal
    makeWrapper
    nodejs
    pnpm
    pnpmConfigHook
    python3
    zip
  ];

  postPatch = ''
    substituteInPlace desktop/src/updates.ts \
      --replace-fail "export const UPDATES_ENABLED = true;" "export const UPDATES_ENABLED = false;"

    # We launch via the system electron, so process.resourcesPath points at
    # electron's own resources dir, not ours. Inject the real path as the
    # first candidate. (GOOSE_BINARY env is rejected in packaged mode.)
    substituteInPlace desktop/src/gooseServe.ts \
      --replace-fail "const possiblePaths: string[] = [];" \
        "const possiblePaths: string[] = ['$out/opt/goose-desktop/resources/bin/goose'];"

    # generate-schema.ts resolves these two levels above ui/,
    # which our src (goose-cli.src's ui/ subdir) doesn't include
    mkdir -p ../crates/goose
    cp ${goose-cli.src}/crates/goose/acp-schema.json ../crates/goose/
    cp ${goose-cli.src}/crates/goose/acp-meta.json ../crates/goose/
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$(mktemp -d)"
    export npm_config_nodedir=${electron.headers}
    export ELECTRON_PLATFORM=linux
    export ELECTRON_ARCH=x64

    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electron.version}'"

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd
    rm -r electron-dist

    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"

    # Ship the CLI via src/bin so forge keeps it executable outside app.asar.
    install -Dm755 ${lib.getExe goose-cli} desktop/src/bin/goose
    patchShebangs desktop/node_modules desktop/src/bin

    # @aaif/goose-sdk's package.json points at dist/, which must be built
    # (schema generation + tsc) before vite can resolve the workspace dep
    pnpm --dir sdk run build

    node desktop/scripts/prepare-platform-binaries.js
    pnpm --dir desktop run i18n:compile
    pnpm --dir desktop exec electron-forge package --platform=linux --arch=x64

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    buildDir="$(find desktop/out -maxdepth 1 -mindepth 1 -type d -name '*-linux-x64' | head -n1)"

    mkdir -p "$out/opt/goose-desktop"
    cp -r "$buildDir/resources" "$out/opt/goose-desktop/"

    install -Dm644 desktop/src/images/icon.png \
      "$out/share/icons/hicolor/256x256/apps/goose-desktop.png"
    install -Dm644 desktop/src/images/icon.svg \
      "$out/share/icons/hicolor/scalable/apps/goose-desktop.svg"

    makeWrapper ${lib.getExe electron} "$out/bin/goose-desktop" \
      --run "cd $out/opt/goose-desktop/resources" \
      --add-flags "$out/opt/goose-desktop/resources/app.asar" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          python3
          coreutils
          curl
          gnused
          gzip
          which
          xdotool
          wmctrl
          xclip
          xwininfo
          wtype
          wl-clipboard
        ]
      } \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "goose-desktop";
      desktopName = "Goose";
      comment = finalAttrs.meta.description;
      exec = "goose-desktop %U";
      icon = "goose-desktop";
      categories = [ "Development" ];
      startupWMClass = "Goose";
      mimeTypes = [ "x-scheme-handler/goose" ];
    })
  ];

  passthru.tests.smoke = runCommand "${finalAttrs.pname}-smoke" { } ''
    ${finalAttrs.finalPackage}/opt/goose-desktop/resources/bin/goose --version >/dev/null
    touch "$out"
  '';

  meta = {
    description = "Desktop client for Goose";
    homepage = "https://github.com/aaif-goose/goose";
    changelog = "https://github.com/aaif-goose/goose/releases/tag/${goose-cli.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "goose-desktop";
    maintainers = goose-cli.meta.maintainers;
    platforms = [ "x86_64-linux" ];
  };
})
