{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "1gy0iv39arq2ri57iqsycp1sfnn1yafnhblr7p1my2wnmqwmd4qw";
  };

  cargoSha256 = "01b4dlbakkdn3pfyyphabzrmqyp7fjy6n1nfk38z3zap5zvx8ipl";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
