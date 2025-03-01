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
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    tag = "v${version}";
    hash = "sha256-h/sytTRufqFgnhbg67qtTx6XhnC/UzgT4zFq4bJYhQM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dS90DVFmXOFBv7qKfsOpR5WvdRqR9ZqmapXaCVdG3ic=";

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

  meta = with lib; {
    description = "Tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
