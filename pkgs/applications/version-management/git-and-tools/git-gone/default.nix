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
  version = "0.4.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "flausch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kqKFs3xvTVHnsLpLC9gjj1dcPChhegmupNrbWy+7C6o=";
  };

  cargoSha256 = "sha256-8R13eHS69fQ3r3LYlnB3nPTPX7VesUPlAUCmQEpUUdw=";

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
