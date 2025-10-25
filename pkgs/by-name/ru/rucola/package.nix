{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "rucola";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Linus-Mussmaecher";
    repo = "rucola";
    rev = "v${version}";
    hash = "sha256-BbR6m5meOyz1YpmBzhdyVvfhO15Qb/pDAXrMZUELK6Y=";
  };

  cargoHash = "sha256-asHlSvjYCnLCfd4xBZrjO9E499jcPktCV4cDgOf0kr8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # Fails on Darwin
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=io::file_tracker::tests::test_watcher_rename"
  ];

  meta = {
    description = "Terminal-based markdown note manager";
    homepage = "https://github.com/Linus-Mussmaecher/rucola";
    changelog = "https://github.com/Linus-Mussmaecher/rucola/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "rucola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
