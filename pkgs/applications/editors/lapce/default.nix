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
  Security,
  CoreServices,
  ApplicationServices,
  Carbon,
  AppKit,
  wrapGAppsHook3,
  wayland,
  gobject-introspection,
  xorg,
}:
let
  rpathLibs = lib.optionals stdenv.isLinux [
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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = "lapce";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-x/EObvrMZ3bkdHk5SbfQEarXA7jcQ9rEFZINQrHjcl4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "floem-0.1.1" = "sha256-/RUsi0LUJ/LjDj8xjoiF+f4MeUjFASL0TDS0eDUEHio=";
      "human-sort-0.2.2" = "sha256-tebgIJGXOY7pwWRukboKAzXY47l4Cn//0xMKQTaGu8w=";
      "lsp-types-0.95.1" = "sha256-+tWqDBM5x/gvQOG7V3m2tFBZB7smgnnZHikf9ja2FfE=";
      "psp-types-0.1.0" = "sha256-/oFt/AXxCqBp21hTSYrokWsbFYTIDCrHMUBuA2Nj5UU=";
      "regalloc2-0.9.3" = "sha256-tzXFXs47LDoNBL1tSkLCqaiHDP5vZjvh250hz0pbEJs=";
      "structdesc-0.1.0" = "sha256-gMTnRudc3Tp9JRa+Cob5Ke23aqajP8lSun5CnT13+eQ=";
      "tracing-0.2.0" = "sha256-31jmSvspNstOAh6VaWie+aozmGu4RpY9Gx2kbBVD+CI=";
      "tree-sitter-bash-0.19.0" = "sha256-gTsA874qpCI/N5tmBI5eT8KDaM25gXM4VbcCbUU2EeI=";
      "tree-sitter-md-0.1.2" = "sha256-gKbjAcY/x9sIxiG7edolAQp2JWrx78mEGeCpayxFOuE=";
      "tree-sitter-yaml-0.0.1" = "sha256-bQ/APnFpes4hQLv37lpoADyjXDBY7J4Zg+rLyUtbra4=";
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
    ++ lib.optionals stdenv.isLinux [
      fontconfig
    ]
    ++ lib.optionals stdenv.isDarwin [
      libobjc
      Security
      CoreServices
      ApplicationServices
      Carbon
      AppKit
    ];

  postInstall =
    if stdenv.isLinux then
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
    # Undefined symbols for architecture x86_64: "_NSPasteboardTypeFileURL"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
