# generate the script used to activate the configuration.
{pkgs, config, ...}:

let
  inherit (pkgs.stringsWithDeps) textClosureMap noDepEntry;
  inherit (pkgs.lib) mkOption mergeTypedOption mergeAttrs mapRecordFlatten
    mapAttrs addErrorContext fold id filter;
  inherit (builtins) attrNames;

  addAttributeName = mapAttrs (a: v: v // {
      text = ''
        #### actionScripts snippet ${a} :
        #    ========================================
        ${v.text}
      '';
    });
in

{
  system = {
    activationScripts = mkOption {
      default = [];
      example = {
        stdio = {
          text = "
            # Needed by some programs.
            ln -sfn /proc/self/fd /dev/fd
            ln -sfn /proc/self/fd/0 /dev/stdin
            ln -sfn /proc/self/fd/1 /dev/stdout
            ln -sfn /proc/self/fd/2 /dev/stderr
          ";
          deps = [];
        };
      };
      description = ''
        Activate the new configuration (i.e., update /etc, make accounts,
        and so on).
      '';
      merge = mergeTypedOption "script" builtins.isAttrs (fold mergeAttrs {});
      apply = set:
        let withHeadlines = addAttributeName set;
            activateLib = removeAttrs withHeadlines ["activate"];
            activateLibNames = attrNames activateLib;
        in {
        script = pkgs.writeScript "nixos-activation-script"
          ("#!/bin/sh\n"
           + textClosureMap id activateLib activateLibNames + "\n"
             # make sure that the activate snippet is added last.
           + withHeadlines.activate.text);
      };
    };
  };
}
