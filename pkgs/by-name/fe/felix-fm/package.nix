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
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    tag = "v${version}";
    hash = "sha256-PcC0lZ41qTVE4V3VdwBq83qYfEJO3RJouuS2+bpcBfo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RFv1/LZ3PSNKkd7C1pzIsHPEubt47ThOrTOvjCdPb8M=";

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
