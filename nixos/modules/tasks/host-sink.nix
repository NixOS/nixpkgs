{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.hostSink;

  sources = [
    https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
    https://mirror1.malwaredomains.com/files/justdomains
    http://sysctl.org/cameleon/hosts
    https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
    https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
    https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
    https://hosts-file.net/ad_servers.txt
    http://winhelp2002.mvps.org/hosts.txt
  ];

  sinkParser = pkgs.writeText "sinkholes.awk" ''
    BEGIN { sinkhole="" }

    !/^#/ && $1 ~ /^0.0.0.0||^127.0.0.1/ && $2 ~ !/localhost/ {
        if (NF == 2) { sinkhole = sinkhole "\n" $2 }
    }

    END { print sinkhole }
  '';

  hostFmt = pkgs.writeText "hosts.awk" ''
    // { print "0.0.0.0 " $1 }
  '';
  unboundFmt = pkgs.writeText "unbound-localdata.awk" ''
    // { print "local-data: \"" $1 " A 0.0.0.0\"" }
  '';

  upstreams = map builtins.fetchurl sources;

  inputHosts = pkgs.stdenv.mkDerivation {
    name = "host-blacklists";
    phases = [ "installPhase" ];
    installPhase = ''
       for up in ${lib.concatStringsSep " " upstreams};do
         awk -f ${sinkParser} $up >> allHosts
       done
       sed -i -e '/^$/d' -e 's/\r$//g' allHosts
       mkdir -p $out
       awk -f ${hostFmt} allHosts | sort -u > $out/hosts
       awk -f ${unboundFmt} allHosts | sort -u > $out/unbound-localdata.conf
    '';
  };

in

{

  options.networking.hostSink.enable =
    mkEnableOption "Tracker and Ad host sinkhole";

  config = mkIf cfg.enable {

    networking.extraHosts =
      builtins.readFile (inputHosts + "/hosts");

    services.unbound.extraConfig = mkIf (services.unbound.enable)
      builtins.readFile (inputHosts + "/unbound-localdata.conf");

  };

}
