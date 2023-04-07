{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6oqUBLda6/qcRza5898WXjdopF8jKBDd93FdM0QwNUo=";
  };

  cargoSha256 = "sha256-SfcO8nMle1ku3lK2UPW/Z+J4JzmhcoFr+UCGIidXOa0=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
