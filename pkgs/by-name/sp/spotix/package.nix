{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  pkg-config,
  alsa-lib,
  glib,
  gtk3,
  pango,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spotix";
  version = "0-unstable-2025-12-21";

  src = fetchFromGitHub {
    owner = "skyline69";
    repo = "spotix";
    rev = "c551160b13b14b841d2c636ab14cc71f70e65f07";
    leaveDotGit = true;
    hash = "sha256-DY+G9uwpkE4AbhoarYmQ6JQFjeKr/AIddHavnGTxCzs=";
    # hash = "sha256-uMQm0XF0Myd59xho9HeM954PP53AXdXRQ5HO+LBH35A=";
  };

  preBuild = ''
    rm -rf spotix-core/build.rs
    # mkdir -p $OUT_DIR
    # echo "https://github.com/skyline69/spotix" > $OUT_DIR/remote-url.txt
    # echo "" > $OUT_DIR/remote-url.txt
    # echo "" > $OUT_DIR/build-time.txt
    substituteInPlace spotix-core/src/lib.rs \
      --replace-fail \
        'pub const BUILD_TIME: &str = include!(concat!(env!("OUT_DIR"), "/build-time.txt"));' \
        'pub const BUILD_TIME: &str = "";' \
      --replace-fail \
        'pub const REMOTE_URL: &str = include!(concat!(env!("OUT_DIR"), "/remote-url.txt"));' \
        'pub const REMOTE_URL: &str = "https://github.com/skyline69/spotix";'
  '';

  env = {
    # OUT_DIR = "${placeholder "out"}";
  };

  nativeBuildInputs = [
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    glib
    gtk3
    pango
  ];

  cargoHash = "sha256-4hCFldc3bKJJkYYDUvs6wZ48+jixLJgq1cy81j+SKb4=";

  meta = {
    description = "Fast, native Spotify client written in Rust";
    homepage = "https://github.com/skyline69/spotix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "spotix";
  };
})
