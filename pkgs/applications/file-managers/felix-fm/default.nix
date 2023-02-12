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
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qN/aOOiSj+HrjZQaDUkps0NORIdCBIevVjTYQm2G2Fg=";
  };

  cargoSha256 = "sha256-xqWDWN3xkzBwgW0f64QhYHfsOS3Ed50jlQFuHG81/KY=";

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
    "--skip=magic_image::tests::test_inspect_image"
    "--skip=magic_packed::tests::test_inspect_signature"
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
