{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  bzip2,
  libgit2,
  nix-update-script,
  zlib,
  zstd,
  zoxide,
}:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "refs/tags/v${version}";
    hash = "sha256-7KuL3YkKhjcZSMSipbNITaA9/MGo54f3lz3fVOgy52s=";
  };

  cargoPatches = [
    # https://github.com/kyoheiu/felix/pull/292
    (fetchpatch2 {
      name = "update-cargo.lock-for-2.13.0.patch";
      url = "https://github.com/kyoheiu/felix/commit/5085b147103878ee8138d4fcf7b204223ba2c3eb.patch";
      hash = "sha256-7Bga9hcJCXExA/jnrR/HuZgOOVBbWs1tdTwxldcvdU8=";
    })
    ./0001-update-time.patch
  ];

  cargoHash = "sha256-QVk7yyldGrzkcgQvJpXq55+mcguKkXasDGV5bjKNQjg=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
