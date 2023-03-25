{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
  # libgit2-sys doesn't support libgit2 1.6 yet
, libgit2_1_5
, oniguruma
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "git-dive";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "gitext-rs";
    repo = "git-dive";
    rev = "v${version}";
    hash = "sha256-LOvrPId/GBWPq73hdCdaMNKH7K7cmGmlkepkQiwGC60=";
  };

  cargoHash = "sha256-JDybjIUjj9ivJ5hJJB9bvGB18TdwEXQZfKfXPkyopK0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
    oniguruma
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  # don't use vendored libgit2
  buildNoDefaultFeatures = true;

  checkFlags = [
    # requires internet access
    "--skip=screenshot"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "Dive into a file's history to find root cause";
    homepage = "https://github.com/gitext-rs/git-dive";
    changelog = "https://github.com/gitext-rs/git-dive/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
