{lib, fetchgit, rustPlatform}:

let
  repoUrl = "https://codeberg.org/explosion-mental/wallust";
in rustPlatform.buildRustPackage rec {
  pname = "wallust";
  version = "2.4.1";

  src = fetchgit {
    url = "${repoUrl}.git";
    rev = version;
    sha256 = "sha256-7zSUyj8Zzk8rsDe7ukPaV02HH7VQ+yjh+wM5TZzJxSA=";
  };

  cargoSha256 = "sha256-toqt5vqEsflhqFargEcCXrb6ab748mn6k6/RH5d/3RA=";

  meta = with lib; {
    description = "A better pywall";
    homepage = repoUrl;
    license = licenses.mit;
    maintainers = with maintainers; [onemoresuza];
    downloadPage = "${repoUrl}/releases/tag/${version}";
    platforms = platforms.unix;
    mainProgram = "wallust";
  };
}
