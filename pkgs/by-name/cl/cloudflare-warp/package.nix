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
  headless ? false,
}:

let
  version = "2025.6.1335";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${version}.0_amd64.deb";
      hash = "sha256-zb+DrBKUOsNBaUE+2CNtocsDs3bcYpG0nHCnjcnH2Mo=";
    };
    aarch64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${version}.0_arm64.deb";
      hash = "sha256-5DuJKyyr8AUkvuSVrcJYmrc+HAG19wmvrWNN8jrm+wY=";
    };
  };
in
stdenv.mkDerivation rec {
  inherit version;

  pname = "cloudflare-warp" + lib.optionalString headless "-headless";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    versionCheckHook
    makeWrapper
  ]
  ++ lib.optionals (!headless) [
    copyDesktopItems
    desktop-file-utils
  ];

  buildInputs = [
    dbus
    libpcap
    openssl
    nss
    (lib.getLib stdenv.cc.cc)
  ]
  ++ lib.optionals (!headless) [
    gtk3
  ];

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
  ];

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv bin $out
    mv etc $out
    patchelf --replace-needed libpcap.so.0.8 ${libpcap}/lib/libpcap.so $out/bin/warp-dex
    mv lib/systemd/system $out/lib/systemd/
    substituteInPlace $out/lib/systemd/system/warp-svc.service \
      --replace-fail "ExecStart=" "ExecStart=$out"
    ${lib.optionalString (!headless) ''
      substituteInPlace $out/lib/systemd/user/warp-taskbar.service \
        --replace-fail "ExecStart=" "ExecStart=$out" \
        --replace-fail "BindsTo=" "PartOf="

      cat >>$out/lib/systemd/user/warp-taskbar.service <<EOF

      [Service]
      BindReadOnlyPaths=$out:/usr:
      EOF
    ''}
    ${lib.optionalString headless ''
      # For headless version, remove GUI components
      rm $out/bin/warp-taskbar
      rm -r $out/lib/systemd/user
      rm -r $out/etc
      rm -r $out/share/applications
      rm -r $out/share/icons
      rm -r $out/share/warp
    ''}

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/warp-svc --prefix PATH : ${lib.makeBinPath [ nftables ]}
    ${lib.optionalString (!headless) ''
      wrapProgram $out/bin/warp-cli --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
    ''}
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

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
            jq 'last(.tree.[] | select(.path | startswith("src/content/warp-releases/linux/ga/"))).path' |
            rg '([^/]+)\.0\.yaml\b' --only-matching --replace '$1'
        )"

        for platform in ${lib.escapeShellArgs meta.platforms}; do
          update-source-version "${pname}" "$new_version" --ignore-same-version --source-key="sources.$platform"
        done
      '';
    });
  };

  meta = with lib; {
    description =
      "Replaces the connection between your device and the Internet with a modern, optimized, protocol"
      + lib.optionalString headless " (headless version)";
    homepage = "https://pkg.cloudflareclient.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "warp-cli";
    maintainers = with maintainers; [
      marcusramberg
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
