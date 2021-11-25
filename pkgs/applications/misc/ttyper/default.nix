{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9vcoK2mFEivTSZE3KoQRHUr3AfQ/aN5eWP//Jagw3gU=";
  };

  cargoSha256 = "sha256-VzO32b5oAoXR/Ei9up00XRM63I5kuG68TeX4KBCXIdo=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
