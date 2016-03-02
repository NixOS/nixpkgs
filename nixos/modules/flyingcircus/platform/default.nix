# Defines general platform features, like user-management, etc.
#
# This configuration is independent of infrastructure, roles,
# physical/virtual, etc.
#
# It can use parametrized options depending on the ENC or the `data` module.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.flyingcircus;

  get_json = path: default:
    if builtins.pathExists path
    then builtins.fromJSON (builtins.readFile path)
    else default;

  enc =
    get_json cfg.enc_path
    (get_json /etc/nixos/enc.json {});

  enc_services =
    get_json cfg.enc_services_path {};

  enc_service_clients =
    get_json cfg.enc_service_clients_path {};

  system_state =
    get_json cfg.system_state_path {};

in

{

  imports = [
    ./user.nix
    ./network.nix
    ./ssl/certificate.nix
    ./sensu-client.nix
  ];

  options = {

    flyingcircus.enc = mkOption {
      default = null;
      type = types.nullOr types.attrs;
      description = "Data from the external node classifier.";
    };

    flyingcircus.load_enc = mkOption {
      default = true;
      type = types.bool;
      description = "Automatically load ENC data?";
    };

    flyingcircus.enc_path = mkOption {
      default = /etc/nixos/enc.json;
      type = types.path;
      description = "Where to find the ENC json file.";
    };

    flyingcircus.system_state = mkOption {
      default = {};
      type = types.attrs;
      description = "The current system state as put out by fc-manage";
    };

    flyingcircus.system_state_path = mkOption {
      default = /etc/nixos/system_state.json;
      type = types.path;
      description = "Where to find the system state json file.";
    };

    flyingcircus.enc_services = mkOption {
      default = {};
      type = types.attrs;
      description = "Services in the environment as provided by the ENC.";
    };

    flyingcircus.enc_services_path = mkOption {
      default = /etc/nixos/services.json;
      type = types.path;
      description = "Where to find the ENC services json file.";
    };

    flyingcircus.enc_service_clients = mkOption {
      default = {};
      type = types.attrs;
      description = "Service clients in the environment as provided by the ENC.";
    };

    flyingcircus.enc_service_clients_path = mkOption {
      default = /etc/nixos/service_clients.json;
      type = types.path;
      description = "Where to find the ENC service clients json file.";
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

    flyingcircus.enc = lib.optionalAttrs cfg.load_enc enc;
    flyingcircus.enc_services = enc_services;
    flyingcircus.enc_service_clients = enc_service_clients;
    flyingcircus.system_state = system_state;

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
        python3
        vim
        zlib
        psmisc
        fcagent
    ];

    programs.zsh.enable = true;

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
        nagiosPluginsOfficial = pkgs.nagiosPluginsOfficial.overrideDerivation (oldAttrs: {
          buildInputs = [ pkgs.openssh pkgs.openssl ];
          preConfigure= "
            configureFlagsArray=(
              --with-openssl=${pkgs.openssl}
              --with-ping-command='/var/setuid-wrappers/ping -n -U -w %d -c %d %s'
              --with-ping6-command='/var/setuid-wrappers/ping6 -n -U -w %d -c %d %s'
            )
          ";
        });
      };

    system.activationScripts.flyingcircus_platform = ''
      # /srv must be accessible for unprivileged users
      if [ ! -e /srv ]; then
        install -d -m 0755 /srv
      fi
      chmod 0755 /srv
    '';

    security.sudo.extraConfig =
        ''
        Defaults lecture = never
        root   ALL=(ALL) SETENV: ALL
        %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
        '';

    environment.etc = (
      lib.optionalAttrs (lib.hasAttrByPath ["parameters" "directory_secret"] cfg.enc)
      { "directory.secret".text = cfg.enc.parameters.directory_secret;
        "directory.secret".mode = "0600";}) //
      { "nixos/configuration.nix".text = lib.readFile ../files/etc_nixos_configuration.nix; };
  };
}
