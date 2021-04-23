{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "070jyii2p7qk6gij47n5i9a8bal5iijgn8cv79mrija3pgddniaz";
  };

  cargoSha256 = "113f0hbgy8c9gxl70b6frr0klfc8rm5klgwls7fgbb643rdh03b9";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
