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
    type = with types; attrsOf (submodule { options = import ./github-runner/options.nix args; });
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
    description = ''
      Multiple GitHub Runners.
    '';
  };

  config = {
    systemd.services = flip mapAttrs' cfg (n: v:
      let
        svcName = "github-runner-${n}";
      in
        nameValuePair svcName
        (import ./github-runner/service.nix (args // {
          inherit svcName;
          cfg = v;
          systemdDir = svcName;
        }))
    );
  };
}
