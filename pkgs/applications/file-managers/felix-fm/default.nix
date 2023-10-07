{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, zstd
, zoxide
}:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-RDCX5+Viq/VRb0SXUYxCtWF+aVahI5WGhp9/Vn+uHqI=";
  };

  cargoHash = "sha256-kgI+afly+/Ag0witToM95L9b3yQXP5Gskwl4Lf4SusY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    zstd
  ];

  nativeCheckInputs = [ zoxide ];

  buildFeatures = [ "zstd/pkg-config" ];

  checkFlags = [
    # extra test files not shipped with the repository
    "--skip=functions::tests::test_list_up_contents"
    "--skip=state::tests::test_has_write_permission"
  ];

  # Cargo.lock is outdated
  postConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
