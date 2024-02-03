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
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-bTe8fPFVWuAATXdeyUvtdK3P4vDpGXX+H4TQ+h9bqUI=";
  };

  cargoHash = "sha256-q86NiJPtr1X9D9ym8iLN1ed1FMmEb217Jx3Ei4Bn5y0=";

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
