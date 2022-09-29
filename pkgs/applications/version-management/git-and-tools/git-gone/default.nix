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
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "flausch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S9rNVWq1dbencp9Oy3eNPlJtBMdiFsiJnp5XvHi8hIw=";
  };

  cargoSha256 = "sha256-ZytIBdhyBp0p68ERlXNU8CnK9zYVZaBt/wn8F2bXlII=";

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
