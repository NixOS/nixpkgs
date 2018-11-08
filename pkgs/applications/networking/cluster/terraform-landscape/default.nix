{ lib, bundlerApp, ruby }:
let
  version = (import ./gemset.nix).terraform_landscape.version;
in bundlerApp {
  pname = "terraform_landscape";

  inherit ruby;
  gemdir = ./.;
  exes = [ "landscape" ];

  meta = with lib; {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage    = https://github.com/coinbase/terraform-landscape;
    license     = with licenses; apsl20;
    maintainers = with maintainers; [ mbode manveru ];
    platforms   = platforms.unix;
  };
}
