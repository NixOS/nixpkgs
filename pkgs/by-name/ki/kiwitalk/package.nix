{
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  stdenv,
  stdenvNoCC,
  rustc,
  rustPlatform,
  cargo,
  cargo-tauri,
  openssl,
  libayatana-appindicator,
  webkitgtk,
  pkg-config,
  makeDesktopItem,
  jq,
  moreutils,
  nodePackages,
  cacert,
}:

stdenv.mkDerivation rec {
  pname = "kiwitalk";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "KiwiTalk";
    repo = "KiwiTalk";
    rev = "v${version}";
    hash = "sha256-Th8q+Zbc102fIk2v7O3OOeSriUV/ydz60QwxzmS7AY8=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      # This version of the package has different versions of esbuild as a dependency.
      # You can use the command below to get esbuild binaries for a specific platform and calculate hashes for that platforms. (linux, darwin for os, and x86, arm64, ia32 for cpu)
      # cat package.json | jq '.pnpm.supportedArchitectures += { "os": ["linux"], "cpu": ["arm64"] }' | sponge package.json
      pnpm install --frozen-lockfile --ignore-script

      # Remove timestamp and sort the json files.
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontBuild = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash =
      {
        x86_64-linux = "sha256-LJPjWNpVfdUu8F5BMhAzpTo/h6ax7lxY2EESHj5P390=";
        aarch64-linux = "sha256-N1K4pV5rbWmO/KonvYegzBoWa6TYQIqhQyxH/sWjOJQ=";
        i686-linux = "sha256-/Q7VZahYhLdKVFB25CanROYxD2etQOcRg+4bXZUMqTc=";
        x86_64-darwin = "sha256-9biFAbFD7Bva7KPKztgCvcaoX8E6AlJBKkjlDQdP6Zw=";
        aarch64-darwin = "sha256-to5Y0R9tm9b7jUQAK3eBylLhpu+w5oDd63FbBCBAvd8=";
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-log-0.0.0" = "sha256-8BrFf7vheMJIaZD0oXpi8V4hmUJFzHJmkcRtPL1/J48=";
      "tauri-plugin-single-instance-0.0.0" = "sha256-8BrFf7vheMJIaZD0oXpi8V4hmUJFzHJmkcRtPL1/J48=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodePackages.pnpm
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    openssl
    libayatana-appindicator
    webkitgtk
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpm-deps}
    pnpm install --offline --frozen-lockfile --ignore-script
    pnpm rebuild
    cargo tauri build -b deb
  '';

  preInstall = ''
    mv target/release/bundle/deb/*/data/usr/ $out
    # delete the generated desktop entry
    rm -r $out/share/applications
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "KiwiTalk";
      exec = "kiwi-talk";
      icon = "kiwi-talk";
      desktopName = "KiwiTalk";
      comment = "An UNOFFICIAL cross-platform KakaoTalk client";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      terminal = false;
    })
  ];

  meta = with lib; {
    description = "An UNOFFICIAL cross-platform KakaoTalk client written in TypeScript & Rust (SolidJS, tauri)";
    homepage = "https://github.com/KiwiTalk/KiwiTalk";
    maintainers = with maintainers; [ honnip ];
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "kiwi-talk";
  };
}
