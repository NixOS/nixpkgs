{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "cointop";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = version;
    sha256 = "12yi1lmyd5y4cgcjclkczf93jj7wd6k8aqnhq21dd1mx65l77swv";
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
