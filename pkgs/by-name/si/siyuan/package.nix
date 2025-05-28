{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  replaceVars,
  pandoc,
  nodejs,
  pnpm_9,
  electron,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

let
  pnpm = pnpm_9;

  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux-arm64";
  };

  platformId = platformIds.${stdenv.system} or (throw "Unsupported platform: ${stdenv.system}");

  desktopEntry = makeDesktopItem {
    name = "siyuan";
    desktopName = "SiYuan";
    comment = "Refactor your thinking";
    icon = "siyuan";
    exec = "siyuan %U";
    categories = [ "Utility" ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "siyuan";
  version = "3.1.31";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    rev = "v${finalAttrs.version}";
    hash = "sha256-l9FAGZzu8z5Q4gRoaZ8Z8tYkBEw9Yq9mfmWOKO39KLI=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-uREgNsDGFLzkOBkO2D2/vbJJ8A2rfy0nK2Dx/OvWf9c=";

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
      "-w"
      "-X"
      "github.com/siyuan-note/siyuan/kernel/util.Mode=prod"
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
    pnpm.configHook
    makeWrapper
    copyDesktopItems
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      postPatch
      ;
    hash = "sha256-U8n9FLwJqBq16CTmiIDSh0u4lguSn0rF4jUkU25iu98=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    # remove prebuilt pandoc archives
    rm -r pandoc

    # link kernel into the correct starting place so that electron-builder can copy it to it's final location
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    npm exec electron-builder -- \
        --dir \
        --config electron-builder-${platformId}.yml \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/siyuan
    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --inherit-argv0

    install -Dm644 src/assets/icon.svg $out/share/icons/hicolor/scalable/apps/siyuan.svg

    runHook postInstall
  '';

  desktopItems = [ desktopEntry ];

  passthru = {
    inherit (finalAttrs.kernel) goModules; # this tricks nix-update into also updating the kernel goModules FOD
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [
      tomasajt
      ltrump
    ];
    platforms = lib.attrNames platformIds;
  };
})
