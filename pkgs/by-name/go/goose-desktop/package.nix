{
  lib,
  stdenv,
  fetchurl,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_24,
  pnpm_10,
  electron_41,
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
  pnpm = pnpm_10.override { inherit nodejs; };
  electron = electron_41;
  rollupLinuxX64Gnu = fetchurl {
    url = "https://registry.npmjs.org/@rollup/rollup-linux-x64-gnu/-/rollup-linux-x64-gnu-4.59.0.tgz";
    hash = "sha512-3AHmtQq/ppNuUspKAlvA8HtLybkDflkMuLK4DPo77DfthRb71V84/c4MlWJXixZz4uruIH4uaa07IqoAkG64fg==";
  };
  esbuildLinuxX64 = fetchurl {
    url = "https://registry.npmjs.org/@esbuild/linux-x64/-/linux-x64-0.27.4.tgz";
    hash = "sha512-S5qOXrKV8BQEzJPVxAwnryi2+Iq5pB40gTEIT69BQONqR7JH1EPIcQ/Uiv9mCnn05jff9umq/5nqzxlqTOg9NA==";
  };
  lightningcssLinuxX64Gnu = fetchurl {
    url = "https://registry.npmjs.org/lightningcss-linux-x64-gnu/-/lightningcss-linux-x64-gnu-1.32.0.tgz";
    hash = "sha512-V7Qr52IhZmdKPVr+Vtw8o+WLsQJYCTd8loIfpDaMRWGUZfBOYEJeyJIkqGIDMZPwPx24pUMfwSxxI8phr/MbOA==";
  };
  tailwindcssOxideLinuxX64Gnu = fetchurl {
    url = "https://registry.npmjs.org/@tailwindcss/oxide-linux-x64-gnu/-/oxide-linux-x64-gnu-4.2.2.tgz";
    hash = "sha512-rTAGAkDgqbXHNp/xW0iugLVmX62wOp2PoE39BTCGKjv3Iocf6AFbRP/wZT/kuCxC9QBh9Pu8XPkv/zCZB2mcMg==";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "goose-desktop";
  version = goose-cli.version;
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
    hash = "sha256-DdLhGEKPSKJEF9LyOqBY4BR/JB/o6t9VfQGXWQmMDEI=";
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

    install -Dm755 ${lib.getExe' goose-cli "goosed"} desktop/src/bin/goosed
    patchShebangs desktop/node_modules desktop/src/bin

    mkdir -p node_modules/@rollup/rollup-linux-x64-gnu
    tar -xzf ${rollupLinuxX64Gnu} \
      --strip-components=1 \
      -C node_modules/@rollup/rollup-linux-x64-gnu
    mkdir -p node_modules/@esbuild/linux-x64
    tar -xzf ${esbuildLinuxX64} \
      --strip-components=1 \
      -C node_modules/@esbuild/linux-x64
    tar -xzf ${lightningcssLinuxX64Gnu} \
      --strip-components=1 \
      -C node_modules/lightningcss \
      package/lightningcss.linux-x64-gnu.node
    mkdir -p node_modules/@tailwindcss/oxide-linux-x64-gnu
    tar -xzf ${tailwindcssOxideLinuxX64Gnu} \
      --strip-components=1 \
      -C node_modules/@tailwindcss/oxide-linux-x64-gnu

    node desktop/scripts/prepare-platform-binaries.js
    pnpm --dir desktop run generate-api
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
      --set GOOSED_BINARY "$out/opt/goose-desktop/resources/bin/goosed" \
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
    test -x ${finalAttrs.finalPackage}/bin/goose-desktop
    ${finalAttrs.finalPackage}/opt/goose-desktop/resources/bin/goosed --help >/dev/null
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
