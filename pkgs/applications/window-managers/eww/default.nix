{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk3
, gdk-pixbuf
, withWayland ? false
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wzgWx3QxZvCAzRKLFmo/ru8hsIQsEDNeb4cPdlEyLxE=";
  };

  cargoSha256 = "sha256-9RfYDF31wFYylhZv53PJpZofyCdMiUiH/nhRB2Ni/Is=";

  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gdk-pixbuf ] ++ lib.optional withWayland gtk-layer-shell;

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
