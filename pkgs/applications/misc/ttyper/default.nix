{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fsb77ky92fyv3ll6zrbxbd69gm85xnc6bivj7sc3sv5cxhgr7a5";
  };

  cargoSha256 = "1sqdql0kfr1vsww6hkrp7yjlzx0mnhfma51z699hkx9c492sf1wk";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
