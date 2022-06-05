{ lib
, stdenv
, fetchFromGitea
, rustPlatform
, libiconv
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "flausch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hKbq2rJwEZI3391RsZXsQSjjp7rSqglUckRDYAu42KE=";
  };

  cargoSha256 = "sha256-gBQ4V8Bwx6Di8aVnOYwx0UZZIIOFxZAXT7Tl1Yli0Fk=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

  meta = with lib; {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://codeberg.org/flausch/git-gone";
    changelog = "https://codeberg.org/flausch/git-gone/raw/tag/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
