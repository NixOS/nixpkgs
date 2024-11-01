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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Xf3uR+MG8vRBcad5n5k9NKyfC6v0y3BCz0CfDORsy/Q=";
  };

  cargoHash = "sha256-oywwbDwg6O4pdqRJAM+IAt65DV6IkpMec8v4PY1RoZU=";

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
