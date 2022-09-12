{ config
, pkgs
, lib
, ...
}@args:

with lib;

let
  cfg = config.services.github-runner;
  svcName = "github-runner";

in

{
  options.services.github-runner = import ./github-runner/options.nix args;

  config = mkIf cfg.enable {
    warnings = optionals (isStorePath cfg.tokenFile) [
      ''
        `services.${svgName}.tokenFile` points to the Nix store and, therefore, is world-readable.
        Consider using a path outside of the Nix store to keep the token private.
      ''
    ];

    systemd.services.${svcName} = import ./github-runner/service.nix (args // { inherit svcName; });
  };
}
