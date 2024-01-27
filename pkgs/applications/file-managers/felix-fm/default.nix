{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, libgit2
, zlib
, zstd
, zoxide
}:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-Q+D5A4KVhVuas7sGy0CqN95cvTLAw5LWet/BECjJUPg=";
  };

  cargoHash = "sha256-RfBRm/YiTPxkAN8A+uAoN047DBHEVSL0isQfJgO1Bo0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    libgit2
    zlib
    zstd
  ];

  nativeCheckInputs = [ zoxide ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  buildFeatures = [ "zstd/pkg-config" ];

  checkFlags = [
    # extra test files not shipped with the repository
    "--skip=functions::tests::test_list_up_contents"
    "--skip=state::tests::test_has_write_permission"
  ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
