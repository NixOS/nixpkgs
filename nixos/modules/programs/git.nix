{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
in

{
  options = {
    programs.git = {
      enable = mkEnableOption (lib.mdDoc "git");

      package = mkPackageOption pkgs "git" {
        example = "gitFull";
      };

      config = mkOption {
        type =
          with types;
          let
            gitini = attrsOf (attrsOf anything);
          in
          either gitini (listOf gitini) // {
            merge = loc: defs:
              let
                config = foldl'
                  (acc: { value, ... }@x: acc // (if isList value then {
                    ordered = acc.ordered ++ value;
                  } else {
                    unordered = acc.unordered ++ [ x ];
                  }))
                  {
                    ordered = [ ];
                    unordered = [ ];
                  }
                  defs;
              in
              [ (gitini.merge loc config.unordered) ] ++ config.ordered;
          };
        default = [ ];
        example = {
          init.defaultBranch = "main";
          url."https://github.com/".insteadOf = [ "gh:" "github:" ];
        };
        description = lib.mdDoc ''
          Configuration to write to /etc/gitconfig. A list can also be
          specified to keep the configuration in order. For example, setting
          `config` to `[ { foo.x = 42; } { bar.y = 42; }]` will put the `foo`
          section before the `bar` section unlike the default alphabetical
          order, which can be helpful for sections such as `include` and
          `includeIf`. See the CONFIGURATION FILE section of git-config(1) for
          more information.
        '';
      };

      prompt = {
        enable = mkEnableOption "automatically sourcing git-prompt.sh. This does not change $PS1; it simply provides relevant utility functions";
      };

      lfs = {
        enable = mkEnableOption (lib.mdDoc "git-lfs");

        package = mkPackageOption pkgs "git-lfs" { };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      environment.etc.gitconfig = mkIf (cfg.config != [ ]) {
        text = concatMapStringsSep "\n" generators.toGitINI cfg.config;
      };
    })
    (mkIf (cfg.enable && cfg.lfs.enable) {
      environment.systemPackages = [ cfg.lfs.package ];
      programs.git.config = {
        filter.lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    })
    (mkIf (cfg.enable && cfg.prompt.enable) {
      environment.interactiveShellInit = ''
        source ${cfg.package}/share/bash-completion/completions/git-prompt.sh
      '';
    })
  ];

  meta.maintainers = with maintainers; [ figsoda ];
}
