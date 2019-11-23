{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cointop";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = version;
    sha256 = "0xm616yjqf6qq98yjbdj6lihib2p4fh6jd91dcb59arkbs2l1nbg";
  };

  goPackagePath = "github.com/miguelmota/cointop";

  meta = with lib; {
    description = "The fastest and most interactive terminal based UI application for tracking cryptocurrencies";
    longDescription = ''
      cointop is a fast and lightweight interactive terminal based UI
      application for tracking and monitoring cryptocurrency coin stats in
      real-time.

      The interface is inspired by htop and shortcut keys are inspired by vim.
    '';
    homepage = "https://cointop.sh";
    maintainers = [ maintainers.marsam ];
    license = licenses.asl20;
  };
}
