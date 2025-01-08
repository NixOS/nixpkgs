{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  cmake,
  pkg-config,
  perl,
  python3,
  fontconfig,
  glib,
  gtk3,
  openssl,
  libGL,
  libobjc,
  libxkbcommon,
  wrapGAppsHook3,
  wayland,
  gobject-introspection,
  xorg,
  apple-sdk_11,
}:
let
  rpathLibs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libxcb
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "lapce";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = "lapce";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-vBBYNHgZiW5JfGeUG6YZObf4oK0hHxTbsZNTfnIX95Y=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.24.1-dev" = "sha256-aVB1CNOLjNh6AtvdbomODNrk00Md8yz8QzldzvDo1LI=";
      "floem-0.1.1" = "sha256-/4Y38VXx7wFVVEzjqZ2D6+jiXCXPfzK44rDiNOR1lAk=";
      "human-sort-0.2.2" = "sha256-tebgIJGXOY7pwWRukboKAzXY47l4Cn//0xMKQTaGu8w=";
      "locale_config-0.3.1-alpha.0" = "sha256-cCEO+dmU05TKkpH6wVK6tiH94b7k2686xyGxlhkcmAM=";
      "lsp-types-0.95.1" = "sha256-+tWqDBM5x/gvQOG7V3m2tFBZB7smgnnZHikf9ja2FfE=";
      "psp-types-0.1.0" = "sha256-/oFt/AXxCqBp21hTSYrokWsbFYTIDCrHMUBuA2Nj5UU=";
      "regalloc2-0.9.3" = "sha256-tzXFXs47LDoNBL1tSkLCqaiHDP5vZjvh250hz0pbEJs=";
      "structdesc-0.1.0" = "sha256-KiR0R2YWZ7BucXIIeziu2FPJnbP7WNSQrxQhcNlpx2Q=";
      "tracing-0.2.0" = "sha256-31jmSvspNstOAh6VaWie+aozmGu4RpY9Gx2kbBVD+CI=";
      "wasi-experimental-http-wasmtime-0.10.0" = "sha256-FuF3Ms1bT9bBasbLK+yQ2xggObm/lFDRyOvH21AZnQI=";
    };
  };

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;

    # This variable is read by build script, so that Lapce editor knows its version
    RELEASE_TAG_NAME = "v${version}";
  };

  postPatch = ''
    substituteInPlace lapce-app/Cargo.toml --replace ", \"updater\"" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    python3
    wrapGAppsHook3 # FIX: No GSettings schemas are installed on the system
    gobject-introspection
  ];

  buildInputs =
    rpathLibs
    ++ [
      glib
      gtk3
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
      apple-sdk_11
    ];

  postInstall =
    if stdenv.hostPlatform.isLinux then
      ''
        install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/dev.lapce.lapce.svg
        install -Dm0644 $src/extra/linux/dev.lapce.lapce.desktop $out/share/applications/lapce.desktop

        $STRIP -S $out/bin/lapce

        patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/lapce
      ''
    else
      ''
        mkdir $out/Applications
        cp -r extra/macos/Lapce.app $out/Applications
        ln -s $out/bin $out/Applications/Lapce.app/Contents/MacOS
      '';

  dontPatchELF = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    changelog = "https://github.com/lapce/lapce/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
    mainProgram = "lapce";
  };
}
