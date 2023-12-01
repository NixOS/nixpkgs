{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
, pkg-config
, openssl
, nix-update-script
, testers
, git-workspace
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9/t2MDZ5bYTuzCYTodeATqk+xqST2aQMr7Z1x5fPIuw=";
  };

  cargoSha256 = "sha256-/drXVkYgdkFqZJsz2fNx3Ms21xYKQmwLXRJEmKSaikQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = git-workspace; };
  };

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
    mainProgram = "git-workspace";
  };
}
