{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cointop";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uENfTj+pJjX4t+yrd7zrn3LHRbJJSZFCN1N6Ce47wcE=";
  };

  goPackagePath = "github.com/miguelmota/cointop";

  ldflags = [ "-s" "-w" "-X ${goPackagePath}/cointop.version=${version}" ];

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
