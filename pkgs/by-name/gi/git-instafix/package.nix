{ git
, lib
, libgit2
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

  version = "0.2.7";
in
rustPlatform.buildRustPackage {
  pname = "git-instafix";
  inherit version;

  src = fetchFromGitHub {
    owner = "quodlibetor";
    repo = "git-instafix";
    rev = "v${version}";
    hash = "sha256-Uz+KQ8cQT3v97EtmbAv2II30dUrFD0hMo/GhnqcdBOs=";
  };

  cargoHash = "sha256-12UkZyyu4KH3dcCadr8UhK8DTtVjcsjYzt7kiNLpUqU=";

  buildInputs = [ libgit2 ];
  nativeCheckInputs = [ git ];

  meta = {
    description = "Quickly fix up an old commit using your currently-staged changes";
    mainProgram = "git-instafix";
    homepage = "https://github.com/quodlibetor/git-instafix";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ mightyiam quodlibetor ];
    changelog = "https://github.com/quodlibetor/git-instafix/releases/tag/v${version}";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
