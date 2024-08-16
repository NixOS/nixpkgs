{ lib, bundlerApp, bundlerUpdateScript, ruby }:

bundlerApp rec {
  inherit ruby;

  pname = "terraforming";
  gemdir = ./.;
  exes = [ "terraforming" ];

  passthru.updateScript = bundlerUpdateScript "terraforming";

  meta = with lib; {
    inherit (ruby.meta) platforms;

    description = "Export existing AWS resources to Terraform style (tf, tfstate)";
    homepage    = "https://github.com/dtan4/terraforming";
    license     = with licenses; mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
