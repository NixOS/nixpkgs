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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qAJv4iCw9gkO9yPVQUqla7UWpNkPjPBa4IGQfOyd8k0=";
  };

  cargoHash = "sha256-p+mZN0TXxntT22vp6uBRc6kBTzVN3/Oy7D4v3ihwV8Y=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv Security ];

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
