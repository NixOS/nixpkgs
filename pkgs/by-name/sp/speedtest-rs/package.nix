{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
  testers,
  speedtest-rs,
}:

rustPlatform.buildRustPackage rec {
  pname = "speedtest-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "nelsonjchen";
    repo = "speedtest-rs";
    tag = "v${version}";
    hash = "sha256-1FAFYiWDD/KG/7/UTv/EW6Nj2GnU0GZFFq6ouMc0URA=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-T8OG6jmUILeRmvPLjGDFlJyBm87Xdgy4bw4n7V0BQMk=";

  # Fail for unclear reasons (only on darwin)
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=speedtest::tests::test_get_configuration"
    "--skip=speedtest::tests::test_get_server_list_with_config"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = speedtest-rs; };
  };

  meta = {
    description = "Command line internet speedtest tool written in rust";
    homepage = "https://github.com/nelsonjchen/speedtest-rs";
    changelog = "https://github.com/nelsonjchen/speedtest-rs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "speedtest-rs";
  };
}
