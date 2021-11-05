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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "050zc3w1z9f2vg6sz86mdxf345gd3s3jf09gf4y8y1mqkzs86b8x";
  };

  cargoSha256 = "sha256-LejnTVv9rhL9CVW1fgj2gFv4amHQeziu5uaH2ae8AAw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ] ++ lib.optional withWayland gtk-layer-shell;

  cargoBuildFlags = [ "--bin" "eww" ] ++ lib.optionals withWayland [
    "--no-default-features"
    "--features=wayland"
  ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda legendofmiracles ];
    broken = stdenv.isDarwin;
  };
}
