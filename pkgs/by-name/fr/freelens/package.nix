{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  buildGoModule,
  pnpm_10,
  nodejs,
  electron_41,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  writeShellScript,
  nix-update,
  kubectl,
  kubernetes-helm,
}:

let
  electron = electron_41;
  pnpm = pnpm_10;

  k8sProxy = buildGoModule rec {
    pname = "freelens-k8s-proxy";
    version = "1.7.0";

    src = fetchFromGitHub {
      owner = "freelensapp";
      repo = "freelens-k8s-proxy";
      rev = "v${version}";
      hash = "sha256-6oMxktkJ5p2aqwDoSK2c8YeAu7QBAwR0M7y4L8azX+g=";
    };

    vendorHash = "sha256-wjvA8KlXdR998mTjNnoPUO/1Ch0YTbxleX8gEvxhOrI=";

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];
  };

  resourcesDir =
    if stdenv.hostPlatform.isLinux then
      "$out/share/freelens/resources"
    else if stdenv.hostPlatform.isDarwin then
      "$out/Applications/Freelens.app/Contents/Resources"
    else
      throw "unsupported platform: ${stdenv.hostPlatform.parsed.kernel.name}";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "freelens";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "freelensapp";
    repo = "freelens";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fD3qVU5VLm7S5kkE8MHSFZIvoMDcGbDBcdEdxOHcgNs=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-To09r7xg1lAKdi2c4yctAcUI2Cax70GuKMIvizNmH+g=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    # Disable postbuild which downloads prebuilt freelens-k8s-proxy, kubectl and helm.
    # We symlink them into the resources directory instead.
    substituteInPlace package.json --replace-fail '"postbuild"' '"_postbuild"'

    substituteInPlace packages/core/src/common/vars/lens-resources-dir.injectable.ts \
      --replace-fail "process.resourcesPath" "\"${resourcesDir}\""
  '';

  preBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    cd freelens
    pnpm build:resources:license
    pnpm build:resources:tray
    cd ..

    touch freelens/pnpm-lock.yaml

    cd freelens
    pnpm exec electron-builder --dir \
      -c.electronDist=$(realpath ../electron-dist) \
      -c.electronVersion=${electron.version} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/freelens
    cp -r freelens/dist/*-unpacked/resources $out/share/freelens/
    find $out/share/freelens/resources -name '*musl.node' -exec rm -f {} + 2>/dev/null || true

    mkdir -p "$out/share/freelens/resources/${stdenv.hostPlatform.node.arch}"
    ln -sf ${lib.getExe kubectl} "$out/share/freelens/resources/${stdenv.hostPlatform.node.arch}/kubectl"
    ln -sf ${lib.getExe kubernetes-helm} "$out/share/freelens/resources/${stdenv.hostPlatform.node.arch}/helm"
    ln -sf ${k8sProxy}/bin/freelens-k8s-proxy "$out/share/freelens/resources/${stdenv.hostPlatform.node.arch}/freelens-k8s-proxy"

    for size in 16 22 24 32 36 48 64 72 96 128 192 256 512; do
      icon="freelens/build/icons/''${size}x''${size}.png"
      if [ -f "$icon" ]; then
        install -Dm644 "$icon" "$out/share/icons/hicolor/''${size}x''${size}/apps/freelens.png"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r freelens/dist/mac*/Freelens.app $out/Applications/

    mkdir -p "$out/Applications/Freelens.app/Contents/Resources/${stdenv.hostPlatform.node.arch}"
    ln -sf ${lib.getExe kubectl} "$out/Applications/Freelens.app/Contents/Resources/${stdenv.hostPlatform.node.arch}/kubectl"
    ln -sf ${lib.getExe kubernetes-helm} "$out/Applications/Freelens.app/Contents/Resources/${stdenv.hostPlatform.node.arch}/helm"
    ln -sf ${k8sProxy}/bin/freelens-k8s-proxy "$out/Applications/Freelens.app/Contents/Resources/${stdenv.hostPlatform.node.arch}/freelens-k8s-proxy"
  ''
  + ''

    runHook postInstall
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      makeShellWrapper ${lib.getExe electron} $out/bin/freelens \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --set ELECTRON_IS_DEV 0 \
        --add-flags $out/share/freelens/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeShellWrapper $out/Applications/Freelens.app/Contents/MacOS/Freelens $out/bin/freelens
    '';

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = "freelens";
    desktopName = "Freelens";
    exec = "freelens %U";
    icon = "freelens";
    type = "Application";
    comment = "Free IDE for Kubernetes";
    categories = [
      "Development"
      "Network"
    ];
    startupWMClass = "Freelens";
    keywords = [
      "kubernetes"
      "k8s"
      "lens"
    ];
  });

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    inherit k8sProxy;
    updateScript = writeShellScript "update-freelens" ''
      set -euo pipefail
      ${lib.getExe nix-update} freelens --override-filename ${toString ./package.nix}
      ${lib.getExe nix-update} freelens-k8s-proxy --override-filename ${toString ./package.nix}
    '';
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Free IDE for Kubernetes";
    longDescription = ''
      Freelens is a free and open-source user interface designed for managing Kubernetes clusters. It provides a standalone application compatible with macOS, Windows, and Linux operating systems, making it accessible to a wide range of users. The application aims to simplify the complexities of Kubernetes management by offering an intuitive and user-friendly interface.
    '';
    homepage = "https://github.com/freelensapp/freelens/";
    changelog = "https://github.com/freelensapp/freelens/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ skwig ];
    platforms = electron.meta.platforms;
    mainProgram = "freelens";
  };
})
