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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dtOYMZGBnFwas/k3yHSNnKlVwwLUOx7QseshJWY1X4o=";
  };

  cargoSha256 = "sha256-4zqbNhR8A0yPD/qIJgP6049bUunAKRyGmlNmC3yPc5Q=";

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
  };
}
