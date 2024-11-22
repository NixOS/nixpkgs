{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  deno,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,

  openssl,
  webkitgtk_4_1,
  udev,
  libayatana-appindicator,
}:
let
  pname = "opendeck";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "ninjadev64";
    repo = "OpenDeck";
    rev = "refs/tags/v${version}";
    hash = "sha256-P6STPT/JMKrPeTbxSwHt2y0q8XexPVjpgFPRMWtvJt4=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  postPatch = ''
    # Very strangely, OpenDeck does not use a Cargo workspace for Tauri and instead has its Rust
    # component entirely with src-tauri — buildRustPackage really dislikes this so we symlink the
    # Cargo.lock to the root directory. Setting sourceRoot also breaks tauri build as it assumes
    # the build directory to be at the project root, where the node_modules are.
    #
    # It's a mess.
    ln -s src-tauri/Cargo.lock Cargo.lock
  '';

  denoDeps = deno.fetchDeps {
    inherit pname src;
    hash = "sha256-2Oal3jpbK+QfaoR3RW5WlRX4SQustNpgOdLYYH6PjT0=";
    denoInstallFlags = [ "--allow-scripts" ];
  };

  cargoHash = "sha256-7CZJZFZukEQjjH+ri32LfJ+/dR7Xo4vDv69lDt2ItO8=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  nativeBuildInputs = [
    deno.setupHook
    nodejs
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    makeBinaryWrapper
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      webkitgtk_4_1
      udev
      libayatana-appindicator
    ];

  postInstall = ''
    # Somehow the udev rules aren't autoinstalled
    install -Dm644 src-tauri/bundle/40-streamdeck.rules -t $out/lib/udev/rules.d
  '';

  postFixup = ''
    wrapProgram $out/bin/opendeck \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libayatana-appindicator ]}
  '';

  meta = {
    description = "Cross-platform desktop application that provides functionality for stream controller devices";
    homepage = "https://github.com/ninjadev64/OpenDeck";
    changelog = "https://github.com/ninjadev64/OpenDeck/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    mainProgram = "opendeck";
  };
}
