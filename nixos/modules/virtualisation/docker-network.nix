{ config, lib, pkgs, ... }:
with lib;
let
  # Used to identify networks created via nix config
  nixLabel = "NIX_CREATED_BY";
  nixLabelValue = "nix";

  networkType = types.submodule ({ ... }: with types; {
    options = {
      enable = mkOption {
        type = bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the docker network
        '';
      };
      attachable = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Enable manual container attachment
        '';
      };
      aux-address = mkOption {
        type = attrsOf str;
        default = { };
        example = {
          router = "192.168.0.1";
        };
        description = lib.mdDoc ''
          Auxiliary IPv4 or IPv6 addresses used by Network driver
        '';
      };
      config-from = mkOption {
        type = nullOr str;
        default = null;
        example = "myExistingConfigOnlyNetwork";
        description = lib.mdDoc ''
          The network from which to copy the configuration
        '';
      };
      config-only = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Create a configuration only network
        '';
      };
      driver = mkOption {
        type = str;
        default = "bridge";
        description = lib.mdDoc ''
          Driver to manage the Network
        '';
      };
      gateway = mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc ''
          IPv4 or IPv6 Gateway for the master subnet
        '';
      };
      ingress = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Create swarm routing-mesh network
        '';
      };
      internal = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Restrict external access to the network
        '';
      };
      ip-range = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "127.0.0.128/25" ];
        description = lib.mdDoc ''
          Allocate container ip from a sub-range
        '';
      };
      ipam-driver = mkOption {
        type = str;
        default = "default";
        example = "default";
        description = lib.mdDoc ''
          IP Address Management Driver
        '';
      };
      ipam-opt = mkOption {
        type = attrsOf str;
        default = { };
        example = {
          foo = "bar";
        };
        description = lib.mdDoc ''
          Set IPAM driver specific options
        '';
      };
      ipv6 = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc ''
          Enable IPv6 networking
        '';
      };
      label = mkOption {
        type = attrsOf str;
        default = { "${nixLabel}" = nixLabelValue; };
        example = {
          foo = "bar";
        };
        description = lib.mdDoc ''
          Set metadata on a network. NixOS will label this network with "${nixLabel}"="${nixLabelValue}"
        '';
      };
      opt = mkOption {
        type = attrsOf str;
        default = { };
        example = {
          "com.docker.network.bridge.enable_icc" = "true";
        };
        description = lib.mdDoc ''
          Set driver specific options
        '';
      };
      scope = mkOption {
        type = nullOr (enum [ "local" "swarm" "global" "host" ]);
        default = null;
        example = "local";
        description = lib.mdDoc ''
          Control the network's scope
        '';
      };
      subnet = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "127.0.0.1" ];
        description = lib.mdDoc ''
          Subnets in CIDR format that represents a network segment
        '';
      };

    };
  });
  dockerCfg = config.virtualisation.docker;
  cfg = dockerCfg.networks;


  fillNetworkName = network:
    mapAttrs'
      (n: v:
        nameValuePair (n) (recursiveUpdate v { name = n; label.${nixLabel} = nixLabelValue; }))
      network;


  configOnlyNetworks = fillNetworkName (filterAttrs (n: v: v.config-only) cfg);
  normalNetworks = fillNetworkName (filterAttrs (n: v: !v.config-only) cfg);

  mkStringArg = n: v: [ "--${n}" v ];
  mkStringArgs = n: vs: concatMap (mkStringArg n) vs;
  mkKeyValueArgs = optName: optSet: mapAttrsToList (key: value: [ "--${optName}" "${key}=${value}" ]) optSet;
  mkBoolArg = n: v: if v then [ "--${n}" ] else [ ];

  mkNetworkArgs = n: v:
    if isString v then mkStringArg n v
    else if isList v then mkStringArgs n v
    else if isAttrs v then mkKeyValueArgs n v
    else if isBool v then mkBoolArg n v
    else if isNull v then [ ]
    else throw "Unexpected type for network option ${n}: ${typeOf v}";

  filteredAttrs = [ "name" "enable" ]; # Attributes that are used by Nix and not docker
  optionFilter = n: v: ! (elem n filteredAttrs);
  filterNetwork = network: filterAttrs optionFilter network;

  networkArgsList = network: flatten (mapAttrsToList mkNetworkArgs (filterNetwork network));


  mkNetworkService = network:
    let
      serviceName = n: "docker-network-${n}";
      networkArgs = escapeShellArgs (networkArgsList network);

    in
    if !network.enable then null else {
      name = serviceName network.name;
      value =
        let
          docker = "${dockerCfg.package}/bin/docker";
          mkConditionalService = net: cond:
            if cond
            then "${serviceName net}.service"
            else null;
          relationalServicesFor = categoryFn: networks: remove null (mapAttrsToList (n: v: categoryFn n v) (networks));
        in
        {
          description = "Service to create ${network.name} as a docker network.";
          wantedBy = [ "multi-user.target" ];

          after =
            let
              mkAfterServices = net: v: mkConditionalService net (v.enable && v.name == network.config-from);
              afterServices = relationalServicesFor mkAfterServices configOnlyNetworks;
            in
            [ "network.target" "docker.service" ] ++ optionals (network.config-from != null) afterServices;

          requiredBy =
            let
              mkRequiredBy = net: v: mkConditionalService net (v.enable && v.config-from == network.name);
              requiredByServices = relationalServicesFor mkRequiredBy normalNetworks;
            in
            mkIf network.config-only requiredByServices;
          requires = [ "docker.service" ];

          serviceConfig = {
            RemainAfterExit = true;
            Type = "oneshot";
          };

          script = ''
            function isManagedByNix() {
              local LABEL
              LABEL=$(${docker} network inspect ${network.name} --format '{{ index .Labels "${nixLabel}" }}');
              if [ "$LABEL" = "${nixLabelValue}" ]; then
                return 0;
              else
                return 1;
              fi
            }
            check=$( ${docker} network ls | grep -w "${network.name}" || true )
            if [ -z "$check" ]; then
              ${docker} network create ${network.name} ${networkArgs} || {
                echo "Failed to create network ${network.name}"
                exit 10
              }
            else
                if isManagedByNix; then
                  REMOVAL_STATUS=$(${docker} network rm ${network.name} 2>&1 || true)
                  if [ "$REMOVAL_STATUS" = "${network.name}" ]; then
                      ${docker} network create ${network.name} ${networkArgs} || {
                          printf "Failed to create network ${network.name}"
                          exit 10
                      }
                  else
                    printf "Network '%s' already exists. An attempt was made to change the configuration of the network, but it has failed due to the following error: \n%s" "${network.name}" "$REMOVAL_STATUS"
                    exit 12
                  fi
                else
                  printf "Network '%s' already exists. Please remove it manually if you want NixOS to manage it." "${network.name}"
                  exit 13
                fi
            fi
          '';
          preStop = ''
            REMOVAL_STATUS=$(${docker} network rm ${network.name} 2>&1 || true )
            if [ "$REMOVAL_STATUS" != '${network.name}' ]; then
              printf " An attempt was made to remove '%s', but failed due to the following error: \n%s\n." "${network.name}" "$REMOVAL_STATUS"
              exit 15
            fi
          '';
        };
    };
  mkNetworkServiceList = networks:
    listToAttrs (remove null (map mkNetworkService (attrValues (fillNetworkName networks))));
  normalNetworkServices = mkNetworkServiceList normalNetworks;
  configOnlyNetworkServices = mkNetworkServiceList configOnlyNetworks;

in
{
  options.virtualisation.docker.networks = mkOption {
    default = { };
    type = types.attrsOf networkType;
    example = {
      "my-network" = {
        enable = true;
        driver = "bridge";
        label = {
          foo = "bar";
        };
      };
    };
    description = lib.mdDoc ''
      An attribute set of docker networks and their configurations. See https://docs.docker.com/engine/reference/commandline/network_create/ for more info on the options.
    '';
  };

  config = (mkIf dockerCfg.enable {
    assertions =
      let
        conflictingConfigOptionsCheck = network: {
          assertion = !(network.config-only && network.config-from != null);
          message = "Network ${network.name} cannot have both config-only and config-from set";
        };
        configFromExistsCheck = network: {
          assertion = !(network.config-from != null && !(cfg.${network.config-from}.enable or false));
          message = "Network ${network.name} cannot have config-from set to ${network.config-from} as it does not exist";
        };
        allAssertions = concatMap (f: map f (mapAttrsToList (n: v: v) (fillNetworkName cfg))) [
          conflictingConfigOptionsCheck
          configFromExistsCheck
        ];
      in
      allAssertions;

    systemd.services = mkMerge [
      (mkOrder 1100 normalNetworkServices)
      (mkOrder 1000 configOnlyNetworkServices)
    ];
  });
}

