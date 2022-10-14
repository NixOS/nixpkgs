{ config
, pkgs
, lib
, ...
}@args:

with lib;

let
  cfg = config.services.github-runners;

in

{
  options.services.github-runners = mkOption {
    default = {};
    type = with types; attrsOf (submodule { options = import ./github-runner/options.nix (args // { includeNameDefault = false; }); });
    example = {
      runner1 = {
        enable = true;
        url = "https://github.com/owner/repo";
        name = "runner1";
        tokenFile = "/secrets/token1";
      };

      runner2 = {
        enable = true;
        url = "https://github.com/owner/repo";
        name = "runner2";
        tokenFile = "/secrets/token2";
      };
    };
    description = lib.mdDoc ''
      Multiple GitHub Runners.
    '';
  };

  config = {
    systemd.services = flip mapAttrs' cfg (name: v:
      let
        svcName = "github-runner-${name}";
      in
        nameValuePair svcName
        (import ./github-runner/service.nix (args // {
          inherit svcName;
          cfg = v // { inherit name; };
          systemdDir = "github-runner/${name}";
        }))
    );
  };
}
