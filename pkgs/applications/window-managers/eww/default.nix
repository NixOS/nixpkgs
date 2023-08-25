{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk3
, librsvg
, withWayland ? false
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "unstable-2023-06-10";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "25e50eda46379bccd8a7887c18ee35833e0460e8";
    hash = "sha256-8e6gHSg6FDp6nU5v89D44Tqb1lR5aQpS0lXOVqzoUS4=";
  };

  cargoHash = "sha256-dC7yVJdR7mO0n+sxWwigM1Q4tbDv5ZuOINHHlUIPdA0=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 librsvg ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    (if withWayland then "wayland" else "x11")
  ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
