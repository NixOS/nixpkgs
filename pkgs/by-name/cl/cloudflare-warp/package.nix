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
}:

let
  version = "2025.2.600";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${version}.0_amd64.deb";
      hash = "sha256-YY80XGTkKqE5pywuidvXPytv0/uMD4eMIcBlSpEV2Ps=";
    };
    aarch64-linux = fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/noble/main/c/cloudflare-warp/cloudflare-warp_${version}.0_arm64.deb";
      hash = "sha256-ueZL0rX1FCkd7jFpM2c63eu11vFBCUVnl1uOGxPClZU=";
    };
  };
in
stdenv.mkDerivation rec {
  inherit version;

  pname = "cloudflare-warp";

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    versionCheckHook
    makeWrapper
    copyDesktopItems
    desktop-file-utils
  ];

  buildInputs = [
    dbus
    gtk3
    libpcap
    openssl
    nss
    (lib.getLib stdenv.cc.cc)
  ];

  desktopItems = [
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
      --replace "ExecStart=" "ExecStart=$out"
    substituteInPlace $out/lib/systemd/user/warp-taskbar.service \
      --replace "ExecStart=" "ExecStart=$out"

    cat >>$out/lib/systemd/user/warp-taskbar.service <<EOF

    [Service]
    BindReadOnlyPaths=$out:/usr:
    EOF

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/warp-svc --prefix PATH : ${lib.makeBinPath [ nftables ]}
    wrapProgram $out/bin/warp-cli --prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}
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
    description = "Replaces the connection between your device and the Internet with a modern, optimized, protocol";
    homepage = "https://pkg.cloudflareclient.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "warp-cli";
    maintainers = with maintainers; [
      devpikachu
      marcusramberg
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
