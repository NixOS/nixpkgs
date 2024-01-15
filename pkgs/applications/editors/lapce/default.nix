{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, rustPlatform
, cmake
, pkg-config
, perl
, python3
, fontconfig
, glib
, gtk3
, openssl
, libGL
, libobjc
, libxkbcommon
, Security
, CoreServices
, ApplicationServices
, Carbon
, AppKit
, wrapGAppsHook
, wayland
, gobject-introspection
, xorg
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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R7z3E6Moyc6yMFGzfggiYgglLs/A+iOx8ZJKMPhbAz0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_config-0.1.2-dev" = "sha256-6FSi5RU7YOzNIB2kd/O1OKswn54ak6qrLvN/FbJD3g0=";
      "cosmic-text-0.7.0" = "sha256-ATBeQeSlRCuBZIV4Fdam3p+eW5YH8uJadJearZuONrQ=";
      "floem-0.1.0" = "sha256-UVmqF2vkX71o4JBrhIIhd2SkLNBaqibwl51FKLJUo4c=";
      "human-sort-0.2.2" = "sha256-tebgIJGXOY7pwWRukboKAzXY47l4Cn//0xMKQTaGu8w=";
      "peniko-0.1.0" = "sha256-FZu56HLN5rwSWOwIC00FvKShSv4QPCR44l9MURgC+iI=";
      "psp-types-0.1.0" = "sha256-/oFt/AXxCqBp21hTSYrokWsbFYTIDCrHMUBuA2Nj5UU=";
      "structdesc-0.1.0" = "sha256-4j6mJ1H5hxJXr7Sz0UsZxweyAm9sYuxjq8yg3ZlpksI=";
      "tracing-0.2.0" = "sha256-Tc44Mg2Ue4HyB1z+9UBqpjdecJa60ekGXs+npqv22uA=";
      "tree-sitter-bash-0.19.0" = "sha256-gTsA874qpCI/N5tmBI5eT8KDaM25gXM4VbcCbUU2EeI=";
      "tree-sitter-json-0.20.0" = "sha256-pXa6WFJ4wliXHBiuHuqtAFWz+OscTOxbna5iymS547w=";
      "tree-sitter-md-0.1.2" = "sha256-gKbjAcY/x9sIxiG7edolAQp2JWrx78mEGeCpayxFOuE=";
      "tree-sitter-yaml-0.0.1" = "sha256-bQ/APnFpes4hQLv37lpoADyjXDBY7J4Zg+rLyUtbra4=";
      "vger-0.2.7" = "sha256-evri/64mA0TQY7mFn+9bCl3c247V2QEYlwyMPpOcv5Y=";
      "wasi-experimental-http-wasmtime-0.10.0" = "sha256-FuF3Ms1bT9bBasbLK+yQ2xggObm/lFDRyOvH21AZnQI=";
      "winit-0.29.4" = "sha256-Y71QsRiHo0ldUAoAhid3yRDtHyIdd3HJ3AA6YJG04as=";
    };
  };

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;

    # This variable is read by build script, so that Lapce editor knows its version
    RELEASE_TAG_NAME = "v${version}";

  } // lib.optionalAttrs stdenv.cc.isClang {
    # Work around https://github.com/NixOS/nixpkgs/issues/166205.
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  postPatch = ''
    substituteInPlace lapce-app/Cargo.toml --replace ", \"updater\"" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
    python3
    wrapGAppsHook # FIX: No GSettings schemas are installed on the system
    gobject-introspection
  ];

  buildInputs = rpathLibs ++ [
    glib
    gtk3
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
    Security
    CoreServices
    ApplicationServices
    Carbon
    AppKit
  ];

  postInstall = if stdenv.isLinux then ''
    install -Dm0644 $src/extra/images/logo.svg $out/share/icons/hicolor/scalable/apps/dev.lapce.lapce.svg
    install -Dm0644 $src/extra/linux/dev.lapce.lapce.desktop $out/share/applications/lapce.desktop

    $STRIP -S $out/bin/lapce

    patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/lapce
  '' else ''
    mkdir $out/Applications
    cp -r extra/macos/Lapce.app $out/Applications
    ln -s $out/bin $out/Applications/Lapce.app/Contents/MacOS
  '';

  dontPatchELF = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lightning-fast and Powerful Code Editor written in Rust";
    homepage = "https://github.com/lapce/lapce";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ elliot ];
  };
}
