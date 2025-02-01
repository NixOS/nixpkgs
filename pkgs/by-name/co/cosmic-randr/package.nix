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
  version = "1.0.0-alpha.3";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-randr";
    rev = "epoch-${version}";
    hash = "sha256-xakK4APhlNKuWbCMP6nJXLyOaQ0hFCvzOht3P8CkV/0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-S5zvh/pJA3JMwQ3K5RPPHuHKLQA9g1Ae7NLWgy9b5FA=";

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
