{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yg6896p0rdhyrgzrqzprvradmhhxvxg0nwyb52bdah61ng1wz9x";
  };

  cargoSha256 = "1spikgp33asiwnxwaznx9hc5i7a7cy8l4iyj0hl5445l5km6arr4";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
