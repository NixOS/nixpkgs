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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VKesly7Jp1PgukArNKvDGzSRh7DaL3A/Dub3dLR6ET4=";
  };

  cargoSha256 = "sha256-7+4SIBnu4R2mbH2nWBX9BmJL1n8t46d1vrMpNaUHAo4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    zstd
  ];

  checkInputs = [ zoxide ];

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
