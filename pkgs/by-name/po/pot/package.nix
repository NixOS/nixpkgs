{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, nodejs
, pnpm
, wrapGAppsHook3
, cargo
, rustc
, cargo-tauri
, pkg-config
, esbuild
, buildGoModule
, libayatana-appindicator
, gtk3
, webkitgtk
, libsoup
, openssl
, xdotool
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pot";
  version = "2.7.9";

  src = fetchFromGitHub {
    owner = "pot-app";
    repo = "pot-desktop";
    rev = finalAttrs.version;
    hash = "sha256-Y2gFLvRNBjOGxdpIeoY1CXEip0Ht73aymWIP5wuc9kU=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-nRRUX6CH3s1cEoI80gtRmu0ovXpIwS+h1rFJo8kw60E=";
  };

  pnpmRoot = "..";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      # All other crates in the same workspace reuse this hash.
      "tauri-plugin-autostart-0.0.0" = "sha256-/uxaSBp+N1VjjSiwf6NwNnSH02Vk6gQZ/CzO+AyEI7o=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodejs
    pnpm.configHook
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup
    libayatana-appindicator
    openssl
    webkitgtk
    xdotool
  ];

  ESBUILD_BINARY_PATH = "${lib.getExe (esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.18.20";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-mED3h+mY+4H465m02ewFK/BgA1i/PQ+ksUNxBlgpUoI=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  })}";

  preConfigure = ''
    # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
    # TODO: move frontend into its own drv
    chmod +w ..
  '';

  preBuild = ''
    # Use cargo-tauri from nixpkgs instead of pnpm tauri from npm
    cargo tauri build -b deb
  '';

  preInstall = ''
    mv target/release/bundle/deb/*/data/usr/ $out
  '';

  meta = with lib; {
    description = "Cross-platform translation software";
    mainProgram = "pot";
    homepage = "https://pot.pylogmon.com";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
})
