{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-randr";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "epoch-${version}";
    hash = "sha256-mPi6TVUWKlHqLzGL84vSBZYuCjdThVVYc7hv9vq7zho=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3I4ZyZvV9ELBNCvYVYBUHbh9bGw7B/RrwUlam5fdLxU=";

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-randr"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-randr";
    description = "Library and utility for displaying and configuring Wayland outputs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";
  };
}
