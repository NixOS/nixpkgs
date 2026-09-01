{
  lib,
  stdenv,
  callPackage,
  copyDesktopItems,
  electron_43-bin,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchurl,
  makeDesktopItem,
  makeWrapper,
  nodejs_26,
  nodejs-slim_26,
  pnpm_11,
  pnpmConfigHook,
}:

let
  electronVersion = "43.4.0";
  electronPlatform =
    {
      x86_64-linux = "linux-x64";
      aarch64-linux = "linux-arm64";
    }
    .${stdenv.hostPlatform.system};
  electronHash =
    {
      x86_64-linux = "sha256-fF95GLyudKBagUVDlA6yhGnAVe2qPPz0HQ/xeHsxTFI=";
      aarch64-linux = "sha256-FwIdSHOYVxBqJt2Vv3Sflbia6SSVXDx+f/Wj8GJRrBQ=";
    }
    .${stdenv.hostPlatform.system};
  electron = electron_43-bin.overrideAttrs (
    finalElectronAttrs: previousElectronAttrs: {
      version = electronVersion;
      src = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${electronVersion}/electron-v${electronVersion}-${electronPlatform}.zip";
        hash = electronHash;
      };
      passthru = previousElectronAttrs.passthru // {
        dist = "${finalElectronAttrs.finalPackage}/libexec/electron";
      };
    }
  );
  pnpm = pnpm_11.override { nodejs-slim = nodejs-slim_26; };
  daemon = callPackage ./sing-box-daemon.nix { };
  version = "1.14.0";

  # Upstream does not tag desktop releases; this revision matches sing-box 1.14.0.
  # nixpkgs-update: no auto update
  source = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-box-for-desktop";
    rev = "92b69e160d30249e8fc21a1106df6af538f0fb92";
    fetchSubmodules = true;
    hash = "sha256-f3oQG9laLWCiKYR+1yBeWwZMvsyQdh3WtEs/sSO0zGM=";
  };
  dashboardPnpmDeps = fetchPnpmDeps {
    pname = "sing-box-for-desktop-dashboard";
    inherit version pnpm;
    src = source;
    sourceRoot = "source/dashboard";
    fetcherVersion = 4;
    hash = "sha256-MCld/J2LBtAz2bS00ICjCQN/QPXlLDKwzEGtFwlEl8c=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sing-box-for-desktop";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = source;

  patches = [
    ./nix-login-item-launcher.patch
    ./nix-managed-configuration.patch
    ./nix-resources-path.patch
    ./nix-runtime-directory.patch
    ./use-nix-pnpm.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-MJdf1+aTWCmS0l9XO7pAne3ErXhxGmT5xoriSLIUXEk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs_26
    pnpm
    pnpmConfigHook
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    SOURCE_DATE_EPOCH = "1788137407";
  };

  # The dependency FOD enforces upstream's release-age and trust policies while
  # it has registry access. The actual build then trusts that verified lockfile
  # so pnpm does not try to re-fetch registry metadata in the offline sandbox.
  postPatch = ''
    cp ${./managedConfiguration.ts} src/main/managedConfiguration.ts

    substituteInPlace pnpm-workspace.yaml dashboard/pnpm-workspace.yaml \
      --replace-fail \
        'trustPolicyIgnoreAfter: 259200' \
        $'trustPolicyIgnoreAfter: 259200\ntrustLockfile: true'
  '';

  postConfigure = ''
    rootPnpmDeps="$pnpmDeps"
    pnpmDeps=${dashboardPnpmDeps}
    pnpmRoot=dashboard
    pnpmConfigHook
    unset pnpmRoot
    pnpmDeps="$rootPnpmDeps"
  '';

  buildPhase = ''
    runHook preBuild

    pnpm -C dashboard generate

    applicationRoot="$PWD"
    pushd ${daemon.src}
    PATH="$applicationRoot/node_modules/.bin:$PATH" \
      "$applicationRoot/node_modules/.bin/buf" generate \
      --template "$applicationRoot/buf.gen.yaml" \
      --output "$applicationRoot" \
      . \
      --path experimental/boxdd/desktop_service.proto \
      --path daemon/started_service.proto \
      --path daemon/managed_service.proto
    popd

    pnpm exec electron-vite build

    install -Dm755 ${lib.getExe daemon} bin/sing-box-daemon
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm exec electron-builder \
      --dir \
      --config electron-builder.yml \
      --config.electronDist=electron-dist \
      --config.electronVersion=${electron.version} \
      --config.extraMetadata.version=${finalAttrs.version} \
      --config.npmRebuild=false \
      --publish never

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p \
      "$out/bin" \
      "$out/lib/systemd/system" \
      "$out/share/sing-box-for-desktop"
    cp -r release/linux*-unpacked/resources "$out/share/sing-box-for-desktop/"

    makeWrapper ${lib.getExe electron} "$out/bin/sing-box" \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default SING_BOX_LAUNCHER "$out/bin/sing-box" \
      --add-flags "$out/share/sing-box-for-desktop/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -Dm644 resources/icons/512x512.png \
      "$out/share/icons/hicolor/512x512/apps/sing-box.png"
    install -Dm644 resources/icons/1024x1024.png \
      "$out/share/icons/hicolor/1024x1024/apps/sing-box.png"
    install -Dm644 build/io.nekohasekai.sfl.policy \
      "$out/share/polkit-1/actions/io.nekohasekai.sfl.policy"
    install -Dm644 build/io.nekohasekai.sfl.metainfo.xml \
      "$out/share/metainfo/io.nekohasekai.sfl.metainfo.xml"
    install -Dm644 LICENSE \
      "$out/share/licenses/sing-box-for-desktop/LICENSE"

    substitute build/sing-box-daemon.service \
      "$out/lib/systemd/system/sing-box-daemon.service" \
      --replace-fail "/opt/sing-box/resources/daemon/sing-box-daemon" \
        "$out/share/sing-box-for-desktop/resources/daemon/sing-box-daemon"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sing-box";
      desktopName = "sing-box";
      genericName = "SingBox Desktop Client";
      comment = "Linux client for the sing-box universal proxy platform";
      exec = "sing-box %U";
      icon = "sing-box";
      startupWMClass = "sing-box";
      categories = [ "Network" ];
      mimeTypes = [
        "application/x-sing-box-profile"
        "x-scheme-handler/sing-box"
      ];
    })
  ];

  passthru = {
    inherit daemon dashboardPnpmDeps;
    sourceRevision = finalAttrs.src.rev;
    dashboardRevision = "564dd76b2382af2fb72aee9fcc95af75db693d1a";
  };

  meta = {
    description = "Linux desktop client for the sing-box universal proxy platform";
    homepage = "https://github.com/SagerNet/sing-box-for-desktop";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # Electron
    ];
    maintainers = with lib.maintainers; [ snemeow ];
    mainProgram = "sing-box";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
