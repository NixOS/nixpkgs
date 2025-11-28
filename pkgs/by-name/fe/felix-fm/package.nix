{
  lib,
  rustPlatform,
  fetchFromGitHub,
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
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    tag = "v${version}";
    hash = "sha256-QslV0MVbIuiFDmd8A69+7nTPAUhDrn/dndZsIiNkeZ8=";
  };

  cargoHash = "sha256-1JjvfXyjGUHIwJJAlI2pB829kHcPrVmKOp+msDk5Qp4=";

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
    maintainers = with lib.maintainers; [ _7karni ];
    mainProgram = "fx";
  };
}
