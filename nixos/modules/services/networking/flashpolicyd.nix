{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.flashpolicyd;

  flashpolicyd = pkgs.stdenv.mkDerivation {
    name = "flashpolicyd-0.6";

    src = pkgs.fetchurl {
      name = "flashpolicyd_v0.6.zip";
      url = "https://download.adobe.com/pub/adobe/devnet/flashplayer/articles/socket_policy_files/flashpolicyd_v0.6.zip";
      sha256 = "16zk237233npwfq1m4ksy4g5lzy1z9fp95w7pz0cdlpmv0fv9sm3";
    };

    buildInputs = [ pkgs.unzip pkgs.perl ];

    installPhase = "mkdir $out; cp -pr * $out/; chmod +x $out/*/*.pl";
  };

  flashpolicydWrapper = pkgs.writeScriptBin "flashpolicyd"
    ''
      #! ${pkgs.runtimeShell}
      exec ${flashpolicyd}/Perl_xinetd/in.flashpolicyd.pl \
        --file=${pkgs.writeText "flashpolixy.xml" cfg.policy} \
        2> /dev/null
    '';

in

{

  ###### interface

  options = {

    services.flashpolicyd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            Whether to enable the Flash Policy server.  This is
            necessary if you want Flash applications to make
            connections to your server.
          '';
      };

      policy = mkOption {
        default =
          ''
            <?xml version="1.0"?>
            <!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
            <cross-domain-policy>
              <site-control permitted-cross-domain-policies="master-only"/>
              <allow-access-from domain="*" to-ports="*" />
            </cross-domain-policy>
          '';
        description = "The policy to be served.  The default is to allow connections from any domain to any port.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xinetd.enable = true;

    services.xinetd.services = singleton
      { name = "flashpolicy";
        port = 843;
        unlisted = true;
        server = "${flashpolicydWrapper}/bin/flashpolicyd";
      };

  };

}
