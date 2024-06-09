{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  pnpm,
  cargo,
  rustc,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libsoup,
  openssl,
  webkitgtk,
  libayatana-appindicator,
  clash-meta,
  dbip-country-lite,
  v2ray-geoip,
  v2ray-domain-list-community,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clash-verge";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1oPDrNsL92VUXe7HRIR7zlf45K0xQFIdncC11MRvsP8=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # correct path for resources
    substituteInPlace $cargoDepsCopy/tauri-utils-*/src/platform.rs \
      --replace-fail "\"/usr" "\"$out"

    # skip build sidecar and resources
    sed -i -e '/externalBin/d' -e '/resources/d' tauri.conf.json
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yv7VjLcwIBR5Xh14IAwiUFzjoLgdJV18psKGWzhXULw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "auto-launch-0.5.0" = "sha256-hH3jcPkcwHZToEu/IPJB4Gk/8X+pyRgkE0Fez4hpRD8=";
      "sysproxy-0.3.0" = "sha256-kxpbzWgIrIvQXezF/cnL/R7YmMKxTGCjB5O2NjJ5gDw=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodejs
    pnpm.configHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libsoup
    openssl
    webkitgtk
    libayatana-appindicator
  ];

  preConfigure = ''
    chmod +w ..
  '';

  preBuild = ''
    cargo tauri build -b deb
  '';

  preInstall = ''
    mv target/release/bundle/deb/*/data/usr/ $out
  '';

  postFixup = ''
    ln -sf ${lib.getExe clash-meta} $out/bin/clash-meta
    # nixpkgs doesn't have clash-meta-alpha right now.
    ln -sf ${lib.getExe clash-meta} $out/bin/clash-meta-alpha

    mkdir -p $out/lib/clash-verge/resources
    ln -sf ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources
    ln -sf ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources
    ln -sf ${dbip-country-lite.mmdb} $out/lib/clash-verge/resources/Country.mmdb
  '';

  meta = {
    description = "Clash Meta GUI based on Tauri, Continuation of Clash Verge";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "clash-verge";
    maintainers = with lib.maintainers; [ zendo ];
  };
})
