{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "xplr";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = name;
    rev = "v${version}";
    sha256 = "131ahsl3vc0q0bwmcxj82rd3bfmbd8hmr8igkph2qsdj0qyzajx4";
  };

  cargoSha256 = "1ndpg9hvs88vx7dcvqznppzkdm60q4s68k5c9dsmbw9a4wr3irln";

  meta = with lib; {
    description = "A hackable, minimal, fast TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    maintainers = with maintainers; [ sayanarijit suryasr007 ];
  };
}
