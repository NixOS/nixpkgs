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
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = "felix";
    rev = "v${version}";
    hash = "sha256-d01AbHAIelwjVnVX5hn4QY0sp9n9Ez4ImYqNO/RBmEU=";
  };

  cargoHash = "sha256-n8cVdGvh3/lQ6pF0ukxsog+XpIdpjuxGcgkDkM/3IFk=";

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

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    changelog = "https://github.com/kyoheiu/felix/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
