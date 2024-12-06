{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, git
, gitls
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "licensure";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-bo1bac/K8HMZaeLVYZRqYOS8p+62suGlgSyYz8Atj+0=";
  };

  cargoHash = "sha256-Ywfn+6qdKD9CG2/xdHR2XDsj5LF5XPJ2+XR5H1o2iXk=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl git gitls ]
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
