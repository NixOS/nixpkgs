{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
in

{
  options = {
    programs.git = {
      enable = mkEnableOption (lib.mdDoc "git");

      package = mkOption {
        type = types.package;
        default = pkgs.git;
        defaultText = literalExpression "pkgs.git";
        example = literalExpression "pkgs.gitFull";
        description = lib.mdDoc "The git package to use";
      };

      config = mkOption {
        type = with types; attrsOf (attrsOf anything);
        default = { };
        example = {
          init.defaultBranch = "main";
          url."https://github.com/".insteadOf = [ "gh:" "github:" ];
        };
        description = lib.mdDoc ''
          Configuration to write to /etc/gitconfig. See the CONFIGURATION FILE
          section of git-config(1) for more information.
        '';
      };

      lfs = {
        enable = mkEnableOption (lib.mdDoc "git-lfs");

        package = mkOption {
          type = types.package;
          default = pkgs.git-lfs;
          defaultText = literalExpression "pkgs.git-lfs";
          description = lib.mdDoc "The git-lfs package to use";
        };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      environment.etc.gitconfig = mkIf (cfg.config != {}) {
        text =
        let
          # this is a function that takes a set of includes { includeIf."gitdir:~/path" = { path = ...; _content = {}; } }
          # optionally with a _content subattribute and returns a list
          # that contains each individual include statement and (if _content was set) the value of _content merged into
          flatGit = f: flatten (mapAttrsToList (type: s: mapAttrsToList (key: value: { "${type}"."${key}" = (removeAttrs value [ "_content" ]); } // (if value ? "_content" then value._content else {})) s) f);
        in
          (
            # filter out all the rules that aren't includes, make an ini
            generators.toGitINI (filterAttrs (type: _: type != "include" && type != "includeIf") cfg.config)
          ) + "\n" +
          (
            # iterate over all includes, runs the flatGit function over each include individually
            # and turn each into it's own ini then concat the whole thing
            concatMapStringsSep "\n" generators.toGitINI (flatGit (filterAttrs (type: _: type == "include" || type == "includeIf") cfg.config))
          );
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
  ];

  meta.maintainers = with maintainers; [ figsoda ];
}
