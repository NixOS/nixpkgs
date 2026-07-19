{
  stdenv,
  lib,
  autoPatchelfHook,
  versionCheckHook,
  copyDesktopItems,
  desktop-file-utils,
  dbus,
  dpkg,
  fetchurl,
  gtk3,
  glib,
  iproute2,
  iptables,
  libpcap,
  makeDesktopItem,
  makeWrapper,
  nftables,
  nss,
  openssl,
  writeShellApplication,
  curl,
  jq,
  ripgrep,
  common-updater-scripts,
  xar,
  cpio,
  libayatana-appindicator,
  libappindicator-gtk3,
  libdbusmenu-gtk3,
  hicolor-icon-theme,
  webkitgtk_4_1,
  tpm2-tss,
  procps,
  kmod,
  openresolv,
  systemd,
  coreutils,
  libGL,
  libepoxy,
  libxkbcommon,
  wayland,
  libnotify,
  xdg-utils,
  gsettings-desktop-schemas,
  wireguard-tools,
  headless ? false,
}:

let
  linuxVersion = "2026.6.836.0";
  darwinVersion = "2026.6.822.0";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${linuxVersion}_amd64.deb";
      hash = "sha256-V4y9pZuXAV+Qz3hkj2v5LUAtW3tjADa7FH5PRTZZqb0=";
    };
    aarch64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${linuxVersion}_arm64.deb";
      hash = "sha256-f5nH8Jy1veO49xMEcA+Jf4697axVgJikF2QxmhGLnHs=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cloudflareclient.com/v1/download/macos/version/${darwinVersion}";
      hash = "sha256-YBgj5LPCpVt6n5FK3RvMG4oKScHHdi0TGYweyIAa78c=";
    };
  };

  daemonPath = lib.makeBinPath [
    iproute2
    iptables
    nftables
    procps
    kmod
    openresolv
    systemd
    dbus
    coreutils
    wireguard-tools
  ];

  guiPath = lib.makeBinPath [
    xdg-utils
    dbus
    coreutils
    iproute2
  ];
  guiLibs = lib.makeLibraryPath [
    libGL
    libepoxy
    libxkbcommon
    wayland
    libayatana-appindicator
    libappindicator-gtk3
    libdbusmenu-gtk3
    libnotify
    gtk3
    glib
    nss
  ];
  guiXdgDirs = "${gtk3}/share/gsettings-schemas/${gtk3.name}:${glib.out}/share/glib-2.0/schemas:${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${hicolor-icon-theme}/share";

in
stdenv.mkDerivation (finalAttrs: {
  version = if stdenv.hostPlatform.isDarwin then darwinVersion else linuxVersion;

  pname = "cloudflare-warp" + lib.optionalString headless "-headless";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xar
    cpio
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dpkg
    autoPatchelfHook
    versionCheckHook
  ]
  ++ lib.optionals (!headless && stdenv.hostPlatform.isLinux) [
    copyDesktopItems
    desktop-file-utils
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    [
      dbus
      libpcap
      openssl
      nss
      glib
      (lib.getLib stdenv.cc.cc)
    ]
    ++ lib.optionals (!headless) [
      gtk3
      libayatana-appindicator
      libappindicator-gtk3
      libdbusmenu-gtk3
      webkitgtk_4_1
      tpm2-tss
      libGL
      libepoxy
      libxkbcommon
      wayland
      libnotify
    ]
  );

  desktopItems = lib.optionals (!headless) [
    (makeDesktopItem {
      name = "com.cloudflare.WarpCli";
      desktopName = "Cloudflare Zero Trust Team Enrollment";
      categories = [
        "Utility"
        "Security"
        "ConsoleOnly"
      ];
      noDisplay = true;
      mimeTypes = [ "x-scheme-handler/com.cloudflare.warp" ];
      exec = "warp-cli --accept-tos registration token %u";
      startupNotify = false;
      terminal = true;
    })
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libpcap.so.0.8"
    "libjvm.so"
  ];

  unpackPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preUnpack

    xar -xf $src
    zcat < Cloudflare_WARP_${darwinVersion}.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications $out/bin

        cp -R "Cloudflare WARP.app" $out/Applications/

        for tool in warp-cli warp-dex warp-diag; do
          ln -s "$out/Applications/Cloudflare WARP.app/Contents/Resources/$tool" "$out/bin/$tool"
        done

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mv usr $out
        mv bin $out
        mv etc $out
        patchelf --replace-needed libpcap.so.0.8 ${libpcap}/lib/libpcap.so $out/bin/warp-dex
        mv lib/systemd/system $out/lib/systemd/

        substituteInPlace $out/lib/systemd/system/warp-svc.service \
          --replace-fail "ExecStart=/bin/warp-svc" "ExecStart=$out/bin/warp-svc"

        ${lib.optionalString (!headless) ''
          ln -sf $out/lib/warp/warp-taskbar $out/bin/warp-taskbar

          substituteInPlace $out/lib/systemd/user/warp-taskbar.service \
            --replace-fail "ExecStart=/bin/warp-taskbar" "ExecStart=$out/bin/warp-taskbar"

          # Fix paths in D-Bus services and Desktop entries
          for file in $out/share/applications/*.desktop $out/share/dbus-1/services/*.service; do
            substituteInPlace "$file" \
              --replace-quiet "/usr/lib/warp/warp-taskbar" "$out/bin/warp-taskbar" \
              --replace-quiet "/bin/warp-taskbar" "$out/bin/warp-taskbar" \
              --replace-quiet "Exec=warp-taskbar" "Exec=$out/bin/warp-taskbar"
          done
        ''}

        ${lib.optionalString headless ''
          rm $out/bin/warp-taskbar
          rm -r $out/lib/systemd/user
          rm -r $out/etc
          rm -r $out/share/applications
          rm -r $out/share/icons
          rm -rf $out/lib/warp
        ''}

        mkdir -p $out/libexec

        # Patch hardcoded absolute paths in binaries
        for bin in $out/bin/warp-svc $out/bin/warp-cli $out/bin/warp-dex; do
          sed -i 's|/usr/sbin/ip6tables-restore|warp_ip6tables_restore_2___|g' $bin
          ln -sf ${iptables}/bin/ip6tables-restore $out/libexec/warp_ip6tables_restore_2___ || true

          sed -i 's|/usr/sbin/iptables-restore|warp_iptables_restore_2___|g' $bin
          ln -sf ${iptables}/bin/iptables-restore $out/libexec/warp_iptables_restore_2___ || true

          sed -i 's|/sbin/ip6tables-restore|warp_ip6tables_restore1|g' $bin
          ln -sf ${iptables}/bin/ip6tables-restore $out/libexec/warp_ip6tables_restore1 || true

          sed -i 's|/sbin/iptables-restore|warp_iptables_restore1|g' $bin
          ln -sf ${iptables}/bin/iptables-restore $out/libexec/warp_iptables_restore1 || true

          sed -i 's|/usr/sbin/ip6tables|warp_ip6tables_2___|g' $bin
          ln -sf ${iptables}/bin/ip6tables $out/libexec/warp_ip6tables_2___ || true

          sed -i 's|/usr/bin/resolvectl|warp_resolvectl____|g' $bin
          ln -sf ${systemd}/bin/resolvectl $out/libexec/warp_resolvectl____ || true

          sed -i 's|/usr/sbin/iptables|warp_iptables_2___|g' $bin
          ln -sf ${iptables}/bin/iptables $out/libexec/warp_iptables_2___ || true

          sed -i 's|/sbin/resolvconf|warp_resolvconf_|g' $bin
          ln -sf ${openresolv}/bin/resolvconf $out/libexec/warp_resolvconf_ || true

          sed -i 's|/sbin/ip6tables|warp_ip6tables1|g' $bin
          ln -sf ${iptables}/bin/ip6tables $out/libexec/warp_ip6tables1 || true

          sed -i 's|/sbin/iptables|warp_iptables1|g' $bin
          ln -sf ${iptables}/bin/iptables $out/libexec/warp_iptables1 || true

          sed -i 's|/sbin/modprobe|warp_modprobe1|g' $bin
          ln -sf ${kmod}/bin/modprobe $out/libexec/warp_modprobe1 || true

          sed -i 's|/usr/sbin/nft|warp_nft_1___|g' $bin
          ln -sf ${nftables}/bin/nft $out/libexec/warp_nft_1___ || true

          sed -i 's|/sbin/sysctl|warp_sysctl1|g' $bin
          ln -sf ${procps}/bin/sysctl $out/libexec/warp_sysctl1 || true

          sed -i 's|/sbin/nft|warp_nft_|g' $bin
          ln -sf ${nftables}/bin/nft $out/libexec/warp_nft_ || true

          sed -i 's|/sbin/ip|warp_ip_|g' $bin
          ln -sf ${iproute2}/bin/ip $out/libexec/warp_ip_ || true

          sed -i 's|/bin/ip|warp_ip|g' $bin
          ln -sf ${iproute2}/bin/ip $out/libexec/warp_ip || true
        done

        runHook postInstall
      '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/warp-svc \
      --prefix PATH : $out/libexec:${daemonPath}

    ${lib.optionalString (!headless) ''
      wrapProgram $out/bin/warp-cli \
        --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}

      wrapProgram $out/lib/warp/warp-taskbar \
        --prefix PATH : $out/bin:${guiPath} \
        --prefix LD_LIBRARY_PATH : $out/lib/warp/lib:${guiLibs} \
        --prefix XDG_DATA_DIRS : $out/share:${guiXdgDirs}
    ''}
  '';

  doInstallCheck = stdenv.hostPlatform.isLinux;

  # The Sparkle.framework in the upstream macOS package contains a broken symlink
  # (XPCServices -> Versions/Current/XPCServices) where the target doesn't exist.
  # This is present in the official installed app and doesn't affect functionality.
  dontCheckForBrokenSymlinks = stdenv.hostPlatform.isDarwin;

  passthru = {
    inherit sources;

    updateScript = lib.getExe (writeShellApplication {
      name = "update-cloudflare-warp";

      runtimeInputs = [
        curl
        jq
        ripgrep
        common-updater-scripts
      ];

      text = ''
        new_version="$(
          curl --fail --silent -L ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
            -H 'Accept: application/vnd.github+json' \
            -H 'X-GitHub-Api-Version: 2022-11-28' \
            'https://api.github.com/repos/cloudflare/cloudflare-docs/git/trees/production?recursive=true' |
            jq -r '[.tree[].path | select(startswith("src/content/warp-releases/linux/ga/"))] | max_by(split("/")[-1] | split(".") | map(tonumber?))' |
            rg '([^/]+)\.yaml\b' --only-matching --replace '$1'
        )"

        # Darwin is excluded because its upstream versions differ from Linux.
        # This script is designed specifically to track and verify the linux/ga release directory.
        for platform in x86_64-linux aarch64-linux; do
          update-source-version "${finalAttrs.pname}" "$new_version" --ignore-same-version --source-key="sources.$platform"
        done
      '';
    });
  };

  meta = {
    changelog = "https://github.com/cloudflare/cloudflare-docs/blob/production/src/content/warp-releases/linux/ga/${finalAttrs.version}.yaml";
    description =
      "Replaces the connection between your device and the Internet with a modern, optimized, protocol"
      + lib.optionalString headless " (headless version)";
    homepage = "https://pkg.cloudflareclient.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "warp-cli";
    maintainers = with lib.maintainers; [
      marcusramberg
      anish
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
