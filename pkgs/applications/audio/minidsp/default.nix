{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libusb1,
  AppKit,
  IOKit,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "minidsp";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "mrene";
    repo = "minidsp-rs";
    # v0.1.9 tag is out of date, cargo lock fixed in next commit on main
    rev = "b03a95a05917f20b9c3153c03e4e99dd943d9f6f";
    hash = "sha256-uZBrX3VCCpr7AY82PgR596mncL5wWDK7bpx2m/jCJBE=";
  };

  cargoHash = "sha256-0PyojyimxnwEtHA98Npf4eHvycjuXdPrrIFilVuEnQk=";

  cargoBuildFlags = ["-p minidsp -p minidsp-daemon"];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [libusb1]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [AppKit IOKit];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [pkg-config];

  meta = with lib; {
    description = "Control interface for some MiniDSP products";
    homepage = "https://github.com/mrene/minidsp-rs";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [maintainers.adamcstephens maintainers.mrene];
  };
}
