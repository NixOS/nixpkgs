{
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pnpm_9,
  gobject-introspection,
  nodejs_22,
  cargo,
  cargo-tauri,
  rustc,
  rustup,
  pkg-config,
  gtk3,
  at-spi2-atk,
  atkmm,
  cairo,
  gdk-pixbuf,
  gdm,
  glib,
  harfbuzz,
  librsvg,
  libsoup_3,
  pango,
  webkitgtk_4_1,
  openssl,
  libgudev,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "hslinkupper";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "HSLink";
    repo = "HSLinkUpper";
    rev = "d22bc42d17a72f0e4c586515c4e5a670bcf78d4c";
    hash = "sha256-drYlb2OgHj430CRkrMvEkBryuONp+M+tE24qBOyLgfI=";
  };

  sourceRoot = "${src.name}/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = "sha256-yqNvVXER27OIgrZc9b0a/worOFIkEb3/CQpfguA7ltU=";

  nativeBuildInputs = [
    nodejs_22
    pnpm_9.configHook
    gobject-introspection
    cargo
    cargo-tauri
    rustc
    rustup
    openssl
    gtk3
    pkg-config
  ];

  buildInputs = [
    nodejs_22
    gtk3
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    openssl
    libgudev
    systemd
    gdm
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-sXmh8MxCp6E0kLVR2+vkEh7pKGlCfIrmPEsFrT/o4Gs=";
  };

  preConfigure = ''
    # pnpm.configHook has to write to .., as our sourceRoot is set to src-tauri
    # TODO: move frontend into its own drv
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"

    chmod +w -R ..
  '';

  passthru = {
    inherit pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/HSLink/HSLinkUpper";
    description = "HSLinkUpper is a simple tool that allows you to config HSLink.";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "longcat";
    maintainers = with lib.maintainers; [
      bubblepipe
    ];
  };
}
