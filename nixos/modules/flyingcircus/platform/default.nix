# Defines general platform features, like user-management, etc.
#
# This configuration is independent of infrastructure, roles,
# physical/virtual, etc.
#
# It can use parametrized options depending on the ENC or the `data` module.

{ config, lib, pkgs, ... }:

with lib;

let

    get_enc = path: default:
      if builtins.pathExists path
      then builtins.fromJSON (builtins.readFile path)
      else default;

    enc =
      get_enc config.fcio.enc_path
      (get_enc /etc/nixos/enc.json {});

in

{

  imports = [
    ./user.nix
    ./network.nix
  ];

  options = {

    fcio.enc = mkOption {
      default = null;
      type = types.nullOr types.attrs;
      description = "Essential node configuration";
    };

    fcio.load_enc = mkOption {
      default = true;
      type = types.bool;
      description = "Automatically load ENC data?";
    };

    fcio.enc_path = mkOption {
      default = /etc/nixos/enc.json;
      type = types.path;
      description = "Where to find the ENC json file.";
    };

  };

  config = {

    nix.binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "flyingcircus.io-1:Rr9CwiPv8cdVf3EQu633IOTb6iJKnWbVfCC8x8gVz2o="
    ];

    nix.binaryCaches = [
      https://cache.nixos.org
      https://hydra.flyingcircus.io
    ];

    fcio.enc = lib.optionalAttrs config.fcio.load_enc enc;

    users.motd = ''
        Welcome to the Flying Circus

        Support:   support@flyingcircus.io or +49 345 219401-0
        Status:    http://status.flyingcircus.io/
        Docs:      http://flyingcircus.io/doc/
        Release:   ${config.system.nixosVersion}

      '' + lib.optionalString (enc ? name) ''

        Hostname:  ${enc.name}    Environment: ${enc.parameters.environment}    Location:  ${enc.parameters.location}
        Services:  ${enc.parameters.service_description}

      '';

    environment.noXlibs = true;
    sound.enable = false;

    environment.systemPackages = with pkgs; [
        cyrus_sasl
        db
        dstat
        gcc
        git
        libxml2
        libxslt
        mercurial
        ncdu
        openldap
        openssl
        python27Full
        python27Packages.virtualenv
        vim
        zlib
        fcagent
        zsh
    ];

    environment.pathsToLink = [ "/include" ];
    environment.shellInit = ''
     # help pip to find libz.so when building lxml
     export LIBRARY_PATH=/var/run/current-system/sw/lib
     # help dynamic loading like python-magic to find it's libraries
     export LD_LIBRARY_PATH=$LIBRARY_PATH
     # ditto for header files, e.g. sqlite
     export C_INCLUDE_PATH=/var/run/current-system/sw/include:/var/run/current-system/sw/include/sasl
    '';

    boot.kernelPackages = pkgs.linuxPackages_4_3;

    nixpkgs.config.packageOverrides = pkgs:
      { linux_4_3 = pkgs.linux_4_3.override {
          extraConfig =
            ''
              IPV6_MULTIPLE_TABLES y
              IP_MULTIPLE_TABLES y
            '';
        };
      };

    security.sudo.extraConfig =
        ''
        Defaults lecture = never
        root   ALL=(ALL) SETENV: ALL
        %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
        '';

    environment.etc = (
      lib.optionalAttrs (lib.hasAttrByPath ["parameters" "directory_secret"] config.fcio.enc)
      { "directory.secret".text = config.fcio.enc.parameters.directory_secret;
        "directory.secret".mode = "0600";}) //
      { "nixos/configuration.nix".text = lib.readFile ../files/etc_nixos_configuration.nix; };
  };
}
