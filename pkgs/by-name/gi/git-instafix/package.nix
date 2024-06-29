{ git
, lib
, libgit2
, makeWrapper
, rustPlatform
, stdenv
, fetchFromGitHub
}:
let
  inherit
    (lib)
    licenses
    maintainers
    ;

  version = "0.2.5";
in
rustPlatform.buildRustPackage {
  pname = "git-instafix";
  inherit version;

  src = fetchFromGitHub {
    owner = "quodlibetor";
    repo = "git-instafix";
    rev = "v${version}";
    hash = "sha256-tizA5BLZZ/9gfHv2X8is7EJD1reMvfA7c6JETUoUgvI=";
  };

  cargoHash = "sha256-kIIwswj8mfpY382O0bdMoSk6+T+614l2QCeRgz3ZxEY=";

  buildInputs = [ libgit2 ];
  nativeCheckInputs = [ git ];

  meta = {
    description = "Quickly fix up an old commit using your currently-staged changes";
    mainProgram = "git-instafix";
    homepage = "https://github.com/quodlibetor/git-instafix";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ mightyiam ];
    changelog = "https://github.com/quodlibetor/git-instafix/releases/tag/v${version}";
    broken = stdenv.isDarwin;
  };
}
