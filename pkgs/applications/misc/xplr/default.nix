{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "0dmqa56sxyvrq03rpf9yczp75zk44s79ilz6kbykdghp0d9lyldf";
  };

  cargoSha256 = "1mb1rfax91cbi2wvshl8jsfykx9kfwff8fkqa7rc4plqxnz0qxkx";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
