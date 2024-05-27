{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, git
, gitls
}:
rustPlatform.buildRustPackage rec {
  pname = "licensure";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-y72+k3AaR6iT99JJpGs6WZAEyG6CrOZHLqKRj19gLs0=";
  };

  cargoHash = "sha256-75UNzC+8qjm0A82N63i8YY92wCNQccrS3kIqDlR8pkc=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl git gitls ];

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
