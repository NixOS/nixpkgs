{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  git,
  gitls,
}:
rustPlatform.buildRustPackage rec {
  pname = "licensure";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-rOD2H9TEoZ8JCjlg6feNQiAjvroVGqrlOkDHNZKXDoE=";
  };

  cargoHash = "sha256-ku0SI14pZmbhzE7RnK5kJY6tSMjRVKEMssC9e0Hq6hc=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    git
    gitls
  ];

  checkFlags = [
    # Checking for files in the git repo (git ls-files),
    # That obviously does not work with nix
    "--skip=test_get_project_files"
  ];

  meta = with lib; {
    description = "A FOSS License management tool for your projects";
    homepage = "https://github.com/chasinglogic/licensure";
    license = licenses.gpl3Plus;
    mainProgram = "licensure";
    maintainers = [ maintainers.soispha ];
    platforms = platforms.linux;
  };
}
