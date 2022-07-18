{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk3
, withWayland ? false
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "055il2b3k8x6mrrjin6vkajpksc40phcp4j1iq0pi8v3j7zsfk1a";
  };

  cargoSha256 = "sha256-3hGA730g8E4rwQ9V0wSLUcAEmockXi+spwp50cgf0Mw=";

  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = withWayland;
  buildFeatures = lib.optional withWayland "wayland";

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
    broken = stdenv.isDarwin;
  };
}
