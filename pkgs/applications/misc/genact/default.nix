{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LCKnC6iTr5tmqvL+T+ifYDXJrE8qts4ofCsh81PNg34=";
  };

  cargoSha256 = "sha256-aAcBOLKjHYiuPWgnjXIrNozbu8sG/qt7XoWE4iDvq6I=";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
