{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cointop";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = "v${version}";
    sha256 = "051jxa07c58ym1w0mwckwxh60v28gqcpqw5nv8sm5wxil1crcayr";
  };

  goPackagePath = "github.com/miguelmota/cointop";

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/cointop.version=${version}" ];

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
