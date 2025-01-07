{
  fetchFromGitHub,
  just,
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-randr";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-H7b1y7tujXvaD7E/3nIRAfp2nErASiIxvA1qnYCikt8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+InIQ9DnmdZHg9OdZ9+njSd8F32LaNp6Tmey2u6+jVE=";

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [ wayland ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

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
    platforms = platforms.linux;
    mainProgram = "cosmic-randr";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
