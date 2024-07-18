{
  lib,
  stdenv,
  fetchurl,
  stdenvNoCC,
  wrapGAppsHook3,
  mihomo,
  v2ray-domain-list-community,
  v2ray-geoip,
  openssl,
  makeDesktopItem,
  pkg-config,
  webkitgtk,
  udev,
  libayatana-appindicator,
  nix-update-script,
  dbip-country-lite,
  fetchFromGitHub,
  pnpm,
  nodejs,
  buildGoModule,
  rustPlatform,
  darwin,
  rust,
}:
let
  # declare components and resources required on runtime
  service_components = rustPlatform.buildRustPackage {
    pname = "clash-verge-service";
    version = "unstable-2024-06-28";

    src = fetchFromGitHub {
      owner = "clash-verge-rev";
      repo = "clash-verge-service";
      rev = "e33024d74e1a96bd0385943fcc541818301ee886";
      hash = "sha256-EUeZBwmcDnSci9MHIK/s44wp7ah/daMWbj2wTkHa9vc=";
    };

    cargoHash = "sha256-e9/cvh4TpgwMifRptWG1+dc4yn+JqRcWriEVmZ3lI28=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs =
      [ openssl ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.IOKit
        darwin.apple_sdk.frameworks.Security
      ];

    env = {
      OPENSSL_NO_VENDOR = true;
    };
  };

  set_dns = ./set_dns.sh;
  unset_dns = ./unset_dns.sh;
  country = "${dbip-country-lite}/share/dbip/dbip-country-lite.mmdb";

  # overrideAttrs not play well with buildGoModule. Simply redefine a drv.
  mihomo-alpha = buildGoModule rec {
    pname = "mihomo";
    version = "1.18.6-unstable-2024-06-28";

    src = fetchFromGitHub {
      owner = "MetaCubeX";
      repo = "mihomo";
      rev = "0e228765fce4d709af1e672426dea5294e6b7544";
      hash = "sha256-ZrNnFkkvS8hLEW6u9ZOZ9icehkqlpI4iA3lQf7wM0tg=";
    };

    vendorHash = "sha256-lBHL4vD+0JDOlc6SWFsj0cerE/ypImoh8UFbL736SmA=";

    excludedPackages = [ "./test" ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/metacubex/mihomo/constant.Version=${version}"
    ];

    tags = [ "with_gvisor" ];

    # network required
    doCheck = false;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "clash-verge-rev";
  version = "1.7.2-unstable-2024-07-04";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    rev = "5b7b3be6f9623ccb04bf96972f08f6146cf866dd";
    hash = "sha256-3RyqvYquuX52o+TfD+NnwlQ/laRoquwhVnMOEEz9eWU=";
  };

  ui = stdenvNoCC.mkDerivation {
    inherit src version;
    pname = "${pname}-ui";

    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      hash = "sha256-PEK07nXWoemhqYAHp2+feh7OpMlMDdp+OyJLh52F7S4=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    buildPhase = ''
      runHook preBuild

      pnpm web:build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoLock = {
    lockFile = "${src}/src-tauri/Cargo.lock";
    outputHashes = {
      "sysproxy-0.3.0" = "sha256-TEC51s/viqXUoEH9rJev8LdC2uHqefInNcarxeogePk=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace ./tauri.conf.json \
      --replace-fail '"distDir": "../dist",' '"distDir": "${ui}",' \
      --replace-fail '"beforeBuildCommand": "pnpm run web:build"' '"beforeBuildCommand": ""'

    # install mihomo
    mkdir -p ./sidecar
    ln -s ${mihomo}/bin/mihomo sidecar/verge-mihomo-${rust.envVars.rustHostPlatform}
    ln -s ${mihomo-alpha}/bin/mihomo sidecar/verge-mihomo-alpha-${rust.envVars.rustHostPlatform}

    # install resources
    mkdir -p ./resources
    ln -s ${set_dns} resources/set_dns.sh
    ln -s ${unset_dns} resources/unset_dns.sh
    ln -s ${country} resources/Country.mmdb
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat resources/geosite.dat
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat resources/geoip.dat

    ln -s ${service_components}/bin/clash-verge-service resources/clash-verge-service
    ln -s ${service_components}/bin/install-service resources/install-service
    ln -s ${service_components}/bin/uninstall-service resources/uninstall-service
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  postInstall = ''
    install -DT icons/128x128@2x.png $out/share/icons/hicolor/128x128@2/apps/clash-verge.png
    install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/clash-verge.png
    install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/clash-verge.png
  '';

  postFixup = ''
    mkdir -p $out/lib/clash-verge/resources
    install -Dm755 ${service_components}/bin/{clash-verge,install,uninstall}-service $out/lib/clash-verge/resources

    ln -s ${set_dns} $out/lib/clash-verge/resources/set_dns.sh
    ln -s ${unset_dns} $out/lib/clash-verge/resources/unset_dns.sh
    ln -s ${country} $out/lib/clash-verge/resources/Country.mmdb
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources/geosite.dat
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources/geoip.dat
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "clash-verge %u";
      icon = pname;
      desktopName = "Clash Verge Rev";
      genericName = meta.description;
      mimeTypes = [ "x-scheme-handler/clash" ];
      type = "Application";
      terminal = false;
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Clash GUI based on tauri";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    maintainers = with maintainers; [ Guanran928 ];
    license = licenses.gpl3Plus;
    mainProgram = "clash-verge";
  };
}
