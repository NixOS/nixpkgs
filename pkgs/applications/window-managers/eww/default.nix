{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk3
, librsvg
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "v${version}";
    hash = "sha256-HBBz1NDtj2TnDK5ghDLRrAOwHXDZlzclvVscYnmKGck=";
  };

  cargoHash = "sha256-IirFE714NZmppLjwbWk6fxcmRXCUFzB4oxOxBvmYu5U=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [ gtk3 librsvg gtk-layer-shell ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom coffeeispower ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
