{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  name = "terraform-landscape-${version}";

  version = (import gemset).terraform_landscape.version;
  inherit ruby;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
  gemset = ./gemset.nix;

  meta = with lib; {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage    = https://github.com/coinbase/terraform-landscape;
    license     = with licenses; apsl20;
    maintainers = with maintainers; [ mbode ];
    platforms   = platforms.unix;
  };
}
