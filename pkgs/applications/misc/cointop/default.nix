{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cointop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = version;
    sha256 = "1vhsbk55rrsmnh9b3cxjiv1pzdiip54cyj31j4aj33vlr4hkampn";
  };

  modSha256 = "0vvypp97b3bjwxb96hajpjzr52sb5lc4r3zdkrdgg3vjwwacjwsn";

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
