{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "terraform_landscape";

  gemdir = ./.;
  exes = [ "landscape" ];

  passthru.updateScript = bundlerUpdateScript "terraform-landscape";

  meta = with lib; {
    description = "Improve Terraform's plan output to be easier to read and understand";
    homepage    = "https://github.com/coinbase/terraform-landscape";
    license     = with licenses; asl20;
    maintainers = with maintainers; [ mbode manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
