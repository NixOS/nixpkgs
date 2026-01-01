{
  stdenv,
  lib,
  fetchurl,
  ruby,
}:

let
  rubyEnv = ruby.withPackages (ps: [ ps.snmp ]);
in
stdenv.mkDerivation rec {
  pname = "snmpcheck";
  version = "1.9";
  src = fetchurl {
    url = "http://www.nothink.org/codes/snmpcheck/snmpcheck-${version}.rb";
    sha256 = "sha256-9xkLqbgxU1uykx+M9QsbPAH8OI/Cqn9uw6ALe23Lbq0=";
    executable = true;
  };

  dontUnpack = true;

  buildInputs = [ rubyEnv.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/snmp-check
  '';

<<<<<<< HEAD
  meta = {
    description = "SNMP enumerator";
    homepage = "http://www.nothink.org/codes/snmpcheck/";
    license = lib.licenses.gpl3Plus;
=======
  meta = with lib; {
    description = "SNMP enumerator";
    homepage = "http://www.nothink.org/codes/snmpcheck/";
    license = licenses.gpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "snmp-check";
  };
}
