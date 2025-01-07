{
  fetchFromGitHub,
  flatpak,
  glib,
  just,
  lib,
  libcosmicAppHook,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-store";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-VaOKF3cCnNbfUfJeuhx0wXRvprAnSspTe8gIiR/t2Ng=";
  };
  # Match this to the git commit SHA matching the `src.rev`
  env.VERGEN_GIT_SHA = "9885eee8e7d052712bbbb8bf656727657ec590cd";

  useFetchCargoVendor = true;
  cargoHash = "sha256-Zt2199zlxNbrN/S6bogp4JPM3ZMZpQL5jTXKMki6LQE=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    flatpak
    glib
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-store";

    maintainers = with maintainers; [
      ahoneybun
      nyabinary
      thefossguy
    ];
  };
}
