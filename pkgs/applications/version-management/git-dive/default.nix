{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
  # libgit2-sys doesn't support libgit2 1.6 yet
, libgit2_1_5
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "git-dive";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-dive";
    rev = "v${version}";
    hash = "sha256-zq594j/X74qzRSjbkd2lup/WqZXpTOecUYRVQGqpXug=";
  };

  cargoHash = "sha256-f3hiAVno5BuPgqP1y9XtVQ/TJcnqwUnEOqaU/tTljTQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
    zlib
  ];

  checkFlags = [
    # requires internet access
    "--skip=screenshot"
  ];

  # don't use vendored libgit2
  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = "Dive into a file's history to find root cause";
    homepage = "https://github.com/gitext-rs/git-dive";
    changelog = "https://github.com/gitext-rs/git-dive/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
