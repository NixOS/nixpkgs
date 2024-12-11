{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  apple-sdk_11,
  darwinMinVersionHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "rucola";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Linus-Mussmaecher";
    repo = "rucola";
    rev = "v${version}";
    hash = "sha256-FeQPf9sCEqypvB8VrGa1nnXmxlqo6K4fpLkJakbysvI=";
  };

  cargoHash = "sha256-5TvJ8h/kmXG9G7dl5/gIYhVgvmqmm24BmOJzdKVJ+uY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "10.13")
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
