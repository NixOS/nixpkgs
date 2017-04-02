{ stdenv, lib, bundlerEnv, ruby, makeWrapper, which }:

let
  pname = "ppl-address-book";

  version = (import ./gemset.nix).ppl.version;

  env = bundlerEnv rec {
    name = "${pname}-env-${version}";
    inherit ruby;
    gemdir = ./.;

    gemConfig.rugged = attrs: { buildInputs = [ which ]; };
  };

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  phases = [ "installPhase" ];

  buildInputs = [ env makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/ppl $out/bin/ppl
  '';

  meta = with lib; {
    description = "Address book software for command-line users";
    homepage    = http://ppladdressbook.org/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ chris-martin ];
    platforms   = platforms.unix;
  };

}
