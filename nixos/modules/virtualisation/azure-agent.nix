{ lib, ... }:

lib.warn
  ''
    `virtualisation.azure.agent` provided by `azure-agent.nix` module has been replaced
    by `services.waagent` options, and will be removed in a future release.
  ''
  {

    imports = [
      (lib.mkRenamedOptionModule
        [
          "virtualisation"
          "azure"
          "agent"
          "enable"
        ]
        [
          "services"
          "waagent"
          "enable"
        ]
      )
      (lib.mkRenamedOptionModule
        [
          "virtualisation"
          "azure"
          "agent"
          "verboseLogging"
        ]
        [
          "services"
          "waagent"
          "settings"
          "Logs"
          "Verbose"
        ]
      )
      (lib.mkRenamedOptionModule
        [
          "virtualisation"
          "azure"
          "agent"
          "mountResourceDisk"
        ]
        [
          "services"
          "waagent"
          "settings"
          "ResourceDisk"
          "Format"
        ]
      )
    ];
  }
