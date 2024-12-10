{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  libgit2,
  zlib,
  zstd,
  zoxide,
}:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-M+auLJeD5rDk5LJfTBg9asZ3J4DHsZG4UGRhXdZZVkc=";
  };

  cargoHash = "sha256-GzaBaaGjBCz+xd1bpU2cebQvg5DO0qipHwhOerbq+ow=";

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
