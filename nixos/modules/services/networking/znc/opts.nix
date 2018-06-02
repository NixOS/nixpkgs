{ lib, ... }:

with lib;

let
  networkOpts.options = {
    server = mkOption {
      type = types.str;
      example = "chat.freenode.net";
      description = ''
        IRC server address.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 6697;
      example = 6697;
      description = ''
        IRC server port.
      '';
    };

    userName = mkOption {
      default = "";
      example = "johntron";
      type = types.string;
      description = ''
        A nick identity specific to the IRC server.
      '';
    };

    password = mkOption {
      type = types.str;
      default = "";
      description = ''
        IRC server password, such as for a Slack gateway.
      '';
    };

    useSSL = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to use SSL to connect to the IRC server.
      '';
    };

    modulePackages = mkOption {
      type = types.listOf types.package;
      example = [ "pkgs.zncModules.push" "pkgs.zncModules.fish" ];
      description = ''
        External ZNC modules to build.
      '';
    };

    modules = mkOption {
      type = types.listOf types.str;
      default = [ "simple_away" ];
      example = literalExample "[ simple_away sasl ]";
      description = ''
        ZNC modules to load.
      '';
    };

    channels = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "nixos" ];
      description = ''
        IRC channels to join.
      '';
    };

    hasBitlbeeControlChannel = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to add the special Bitlbee operations channel.
      '';
    };

    extraConf = mkOption {
      default = "";
      type = types.lines;
      example = ''
        Encoding = ^UTF-8
        FloodBurst = 4
        FloodRate = 1.00
        IRCConnectEnabled = true
        Ident = johntron
        JoinDelay = 0
        Nick = johntron
      '';
      description = ''
        Extra config for the network.
      '';
    };
  };

in

{

  options = {
    modules = mkOption {
      type = types.listOf types.str;
      default = [ "webadmin" "adminlog" ];
      example = [ "partyline" "webadmin" "adminlog" "log" ];
      description = ''
        A list of modules to include in the `znc.conf` file.
      '';
    };

    userModules = mkOption {
      type = types.listOf types.str;
      default = [ "chansaver" "controlpanel" ];
      example = [ "chansaver" "controlpanel" "fish" "push" ];
      description = ''
        A list of user modules to include in the `znc.conf` file.
      '';
    };

    userName = mkOption {
      default = "znc";
      example = "johntron";
      type = types.string;
      description = ''
        The user name used to log in to the ZNC web admin interface.
      '';
    };

    networks = mkOption {
      default = { };
      type = with types; attrsOf (submodule networkOpts);
      description = ''
        IRC networks to connect the user to.
      '';
      example = {
        "freenode" = {
          server = "chat.freenode.net";
          port = 6697;
          useSSL = true;
          modules = [ "simple_away" ];
        };
      };
    };

    nick = mkOption {
      default = "znc-user";
      example = "john";
      type = types.string;
      description = ''
        The IRC nick.
      '';
    };

    passBlock = mkOption {
      example = literalExample ''
        # password "nixospass"
        Pass.password = {
          Method = "sha256";
          Hash = "e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93";
          Salt = "l5Xryew4g*!oa(ECfX2o";
        };

        # Or as returned by `znc --makepass` also works:
        <Pass password>
          Method = sha256
          Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
          Salt = l5Xryew4g*!oa(ECfX2o
        </Pass>
      '';
      type = types.string;
      description = ''
        Generate with `nix-shell -p znc --command "znc --makepass"`.
        This is the password used to log in to the ZNC web admin interface.
      '';
    };

    port = mkOption {
      default = 5000;
      example = 5000;
      type = types.int;
      description = ''
        Specifies the port on which to listen.
      '';
    };

    useSSL = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Indicates whether the ZNC server should use SSL when listening on the specified port. A self-signed certificate will be generated.
      '';
    };

    extraZncConf = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to `znc.conf` file.
      '';
    };
  };
}
