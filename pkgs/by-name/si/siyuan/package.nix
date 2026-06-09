{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  replaceVars,
  pandoc,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  xdg-utils,
  darwin,
}:

let
  inherit (stdenv.hostPlatform) isLinux isDarwin system;

  pnpm = pnpm_10;

  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux-arm64";
    "x86_64-darwin" = "darwin";
    "aarch64-darwin" = "darwin-arm64";
  };

  platformId = platformIds.${system} or (throw "Unsupported platform: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "siyuan";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Rz8g03JHQ+52lOd92413ArE4LixioCFNSG7ytduxsA=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-WXlzUtiaphaSngWd6aXQuOHiBb3a3bCNgIHypMP4YXo=";

    patches = [
      (replaceVars ./set-pandoc-path.patch {
        pandoc_path = lib.getExe pandoc;
      })
    ];

    # this patch makes it so that file permissions are not kept when copying files using the gulu package
    # this fixes a problem where it was copying files from the store and keeping their permissions
    # hopefully this doesn't break other functionality
    modPostBuild = ''
      chmod +w vendor/github.com/88250/gulu
      substituteInPlace vendor/github.com/88250/gulu/file.go \
          --replace-fail "os.Chmod(dest, sourceinfo.Mode())" "os.Chmod(dest, 0644)"
    '';

    # Set flags and tags as per upstream's Dockerfile
    ldflags = [
      "-s"
      "-X 'github.com/siyuan-note/siyuan/kernel/util.Mode=prod'"
    ];
    tags = [ "fts5" ];
  };

  # this should contain a 'packages' key, but it doesn't...
  # we can remove it because it's not needed to build
  postPatch = ''
    rm pnpm-workspace.yaml
  '';

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ]
  ++ lib.optionals isLinux [
    pnpmBuildHook
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      postPatch
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-M2Fdie0XK2Pck/fP7Djxb7XNAQXpJO2i2kSJrDj1G0E=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    # remove prebuilt pandoc archives
    rm -r pandoc

    # link kernel into the correct starting place so that electron-builder can copy it to it's final location
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';

  postBuild = ''
    electronBuilderArgs=(
      --dir
      --config electron-builder-${platformId}.yml
      -c.electronDist=electron-dist
      -c.electronVersion=${electron.version}
      -c.mac.identity=null
    )

    npm exec electron-builder -- "''${electronBuilderArgs[@]}"
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString isDarwin ''
    mkdir -p $out/Applications $out/bin

    cp -R build/mac*/*.app $out/Applications/SiYuan.app

    cat > $out/bin/siyuan << EOF
    #!${stdenv.shell}
    exec open -na "$out/Applications/SiYuan.app" --args "\$@"
    EOF
    chmod +x $out/bin/siyuan
  ''
  + lib.optionalString isLinux ''
    mkdir -p $out/share/siyuan

    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --inherit-argv0

    install -Dm644 src/assets/icon.svg $out/share/icons/hicolor/scalable/apps/siyuan.svg
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optional isLinux (makeDesktopItem {
    name = "siyuan";
    desktopName = "SiYuan";
    comment = "Refactor your thinking";
    icon = "siyuan";
    exec = "siyuan %U";
    categories = [ "Utility" ];
  });

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
      "--subpackage=kernel"
    ];
  };

  meta = {
    description = "Privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [
      tomasajt
      ltrump
      myul
    ];
    platforms = lib.attrNames platformIds;
  };
})
