{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cointop";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "miguelmota";
    repo = pname;
    rev = version;
    sha256 = "0nw6vzp0c5r8bwnlvgzj4hzdah44p5pp03d2bcr1lkw8np8fy65n";
  };

  modSha256 = "1fg5h689s6r79qa9qsmd8hcvyihfyzlvqrhhk0qyfl528ipi1zwg";

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
