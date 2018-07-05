{ wrapCommand, lib, bundlerEnv, ruby, which }:

let
  env = bundlerEnv rec {
    name = "ppl-env";
    inherit ruby;
    gemdir = ./.;
    gemConfig.rugged = attrs: { buildInputs = [ which ]; };
  };
in wrapCommand "ppl" {
  inherit (env.gems.ppl) version;
  executable = "${env}/bin/ppl";
  meta = with lib; {
    description = "Address book software for command-line users";
    homepage    = http://ppladdressbook.org/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ chris-martin ];
    platforms   = platforms.unix;
  };
}
