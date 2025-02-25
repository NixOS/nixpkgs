{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  gitls,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "licensure";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-Zd3Jidw3bC/B9vE3zdxDl3UyQNbtwiVBB2VRzBtt7d8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Rua/o1klNDHdCaRqs1HqyFAq1Gq1XssBhuipVNxwrP4=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      openssl
      git
      gitls
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  checkFlags = [
    # Checking for files in the git repo (git ls-files),
    # That obviously does not work with nix
    "--skip=test_get_project_files"
  ];

  meta = with lib; {
    description = "FOSS License management tool for your projects";
    homepage = "https://github.com/chasinglogic/licensure";
    license = licenses.gpl3Plus;
    mainProgram = "licensure";
    maintainers = [ maintainers.bpeetz ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
