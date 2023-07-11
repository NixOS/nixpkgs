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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F2Zw72RdKarrwM47a+Wqe1R1TOK97Ek5AnmAe/0MheY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "syntect-5.0.0" = "sha256-RMdO5+oHLpNlAynvNIbCI0ia4KzaOO9IYwpiX6ZTwno=";
    };
  };

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
