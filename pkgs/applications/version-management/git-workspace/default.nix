{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
, pkg-config
, openssl
, testers
, git-workspace
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rCy6+cjjFgcMqYn48Gfw+tTIMmsTD9lz8h14EfXWatI=";
  };

  cargoSha256 = "sha256-aO9DYD20KQL2cLWy3uIQLJ1oR4PHNbgZLYi/Y8O6UHk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests.version = testers.testVersion { package = git-workspace; };

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
