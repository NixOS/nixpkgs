{
  stdenv,
  lib,
  net-snmp,
  bundlerEnv,
  fetchFromGitHub,
}: let
  rubyEnv = bundlerEnv {
    name = "snmpwn-ruby-env";
    gemdir = ./.;
  };
in
  stdenv.mkDerivation rec {
    pname = "snmpwn";
    version = "0.97b";
    src = fetchFromGitHub {
      owner = "hatlord";
      repo = "snmpwn";
      rev = "0dee1d02e1d24159664ad56533a081f0039a68bf";
      hash = "sha256-qLv6bS+U3PojNesABf2vgU3USEzfiymTz8pEYSIufkQ=";
    };

    buildInputs = [rubyEnv.wrappedRuby];

    postPatch = ''
      substituteInPlace ./snmpwn.rb --replace 'cmd.run!("snmpwalk' 'cmd.run!("${lib.getExe' net-snmp "snmpwalk"}'
    '';

    installPhase = ''
      runHook preBuild
      mkdir -p $out/bin
      cp *.rb $out/bin
      mv $out/bin/snmpwn.rb $out/bin/snmpwn
      runHook postBuild
    '';

    meta = with lib; {
      description = "SNMPv3 user enumerator and attack tool";
      homepage = "https://github.com/hatlord/snmpwn";
      license = licenses.mit;
      maintainers = with maintainers; [bycEEE];
      platforms = platforms.linux;
      mainProgram = "snmpwn";
    };
  }
