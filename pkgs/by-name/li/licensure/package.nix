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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-YPdVVHJ/ldILGbg95x7D06chG8Q6a+NnTAimuvBScpE=";
  };

  cargoHash = "sha256-Vam66mHnDuyVfrbi897DCDmoF812YeGG0KtSYzHrteY=";
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
    maintainers = [ maintainers.soispha ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
