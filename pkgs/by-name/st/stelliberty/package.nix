{
  lib,
  fetchFromGitHub,
  fetchurl,
  buildDotnetModule,
  rustPlatform,
  stdenv,
  dotnetCorePackages,
  cargo,
  dbip-asn-lite, # asn.mmdb
  dbip-country-lite, # country.mmdb
  v2ray-geoip, # geoip.dat
  v2ray-domain-list-community, # geosite.dat
  mihomo,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
  libice,
  libsm,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

let
  google-sans-ttf = fetchurl {
    url = "https://raw.githubusercontent.com/hprobotic/Google-Sans-Font/refs/heads/master/GoogleSans-Regular.ttf";
    hash = "sha256-l07oQCrtc5H47TUVXbEpUGl7y7460Bq/uBcYtlyxlg0=";
  };

  noto-sans-sc-ttf = fetchurl {
    url = "https://raw.githubusercontent.com/notofonts/noto-cjk/main/Sans/Variable/TTF/Subset/NotoSansSC-VF.ttf";
    hash = "sha256-1ouvy0iicHdJOWqhK7vYM8twQB86mmif0pAsfg0pWWQ=";
  };
in

buildDotnetModule (finalAttrs: {
  pname = "stelliberty";
  version = "2.0.25";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kindness-Kismet";
    repo = "stelliberty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WlIUBxLRZUDBONOxviFb2HWBcC2aBqWsvu/KB4igdwU=";
  };

  projectFile = "src/Stelliberty.Desktop/Stelliberty.Desktop.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_11_0;
  dotnet-runtime = dotnetCorePackages.runtime_11_0;
  executables = [ "stelliberty" ];

  postPatch = ''
    substituteInPlace src/Stelliberty.Application/Platform/PortableDataDirectoryResolver.cs \
      --replace-fail "InstallDataDirectory(baseDirectory)" \
      "Path.GetFullPath(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), \"stelliberty\"))"

    substituteInPlace native/hub/src/infra/paths.rs \
      --replace-fail "data_core_dir.join" "user_data_dir.join"

    substituteInPlace native/service/src/core.rs \
      --replace-fail "service_data_root()?.join(\"service\")" "std::env::temp_dir().join(\"stelliberty_service\")"

    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # the upstream does not provide a Cargo.lock
  # https://github.com/Kindness-Kismet/stelliberty/issues/99#issuecomment-5079064300
  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    stdenv.cc # cc-rs
    rustPlatform.cargoSetupHook
    cargo
    copyDesktopItems
  ];

  preBuild = ''
    cargo build --release \
      -p hub \
      -p stelliberty_service \
      --target ${stdenv.hostPlatform.rust.rustcTarget}

    cargo run \
      -p stelliberty_xtask \
      --target ${stdenv.hostPlatform.rust.rustcTarget} \
      -- "generate-bindings"

    mkdir -p src/Stelliberty.Desktop/Assets/fonts
    cp ${google-sans-ttf} src/Stelliberty.Desktop/Assets/fonts
    cp ${noto-sans-sc-ttf} src/Stelliberty.Desktop/Assets/fonts
  '';

  runtimeDeps = [
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    libice
    libsm
  ];

  makeWrapperArgs = [
    "--run"
    "export SAFE_PATHS=$HOME/.config/stelliberty:$SAFE_PATHS"
  ];

  postInstall = ''
    mkdir -p $out/lib/stelliberty/data/{deps,core,service}

    # no geoip.metadb available in nixpkgs
    ln -s ${dbip-asn-lite.mmdb} $out/lib/stelliberty/data/core/ASN.mmdb
    ln -s ${dbip-country-lite.mmdb} $out/lib/stelliberty/data/core/country.mmdb
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/stelliberty/data/core/geoip.dat
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/stelliberty/data/core/geosite.dat
    ln -s ${lib.getExe mihomo} $out/lib/stelliberty/data/core/clash-mihomo-core

    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/stelliberty_service \
      $out/lib/stelliberty/data/service/update/release/stelliberty_service

    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/libhub.so \
      $out/lib/stelliberty/data/deps/libhub.so

    for size in 16 32 64 128 256 512 1024; do
      install -D src/Stelliberty.Desktop/Assets/macos/app_icon_"$size".png \
        $out/share/icons/hicolor/"$size"x"$size"/apps/stelliberty.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "stelliberty";
      desktopName = "Stelliberty";
      exec = "stelliberty";
      terminal = false;
      type = "Application";
      icon = "stelliberty";
      startupNotify = true;
      comment = "Network Proxy Client";
      categories = [
        "Utility"
        "Network"
      ];
      keywords = [
        "proxy"
        "vpn"
        "clash"
      ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
      "--use-github-releases"
    ];
  };

  meta = {
    description = "Cross-platform desktop proxy client";
    homepage = "https://github.com/Kindness-Kismet/stelliberty";
    changelog = "https://github.com/Kindness-Kismet/stelliberty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfreeRedistributable; # source available but prohibits commercial use
    mainProgram = "stelliberty";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux;
  };
})
