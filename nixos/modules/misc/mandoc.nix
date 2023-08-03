{ config, lib, pkgs, ... }:

let
  makewhatis = "${lib.getBin cfg.package}/bin/makewhatis";

  cfg = config.documentation.man.mandoc;

in
{
  meta.maintainers = [ lib.maintainers.sternenseemann ];

  options = {
    documentation.man.mandoc = {
      enable = lib.mkEnableOption (lib.mdDoc "mandoc as the default man page viewer");

      manPath = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "share/man" ];
        example = lib.literalExpression "[ \"share/man\" \"share/man/fr\" ]";
        description = lib.mdDoc ''
          Change the paths included in MANPATH environment variable,
          i. e. the directories where {manpage}`man(1)`
          looks for section-specific directories of man pages.
          You only need to change this setting if you want extra man pages
          (e. g. in non-english languages). All values must be strings that
          are a valid path from the target prefix (without including it).
          The first value given takes priority. Note that this is not
          adding manpath in {manpage}`man.conf(5)`.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mandoc;
        defaultText = lib.literalExpression "pkgs.mandoc";
        description = lib.mdDoc ''
          The `mandoc` derivation to use. Useful to override
          configuration options used for the package.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration to write to {manpage}`man.conf(5)`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc."man.conf".text = cfg.extraConfig;

      # create mandoc.db for whatis(1), apropos(1) and man(1) -k
      # TODO(@sternenseemman): fix symlinked directories not getting indexed,
      # see: https://inbox.vuxu.org/mandoc-tech/20210906171231.GF83680@athene.usta.de/T/#e85f773c1781e3fef85562b2794f9cad7b2909a3c
      extraSetup = lib.mkIf config.documentation.man.generateCaches ''
        for man_path in ${lib.escapeShellArg (map (path: "$out/${path}") cfg.manPath)}
        do
          [[ -d "$man_path" ]] && ${makewhatis} -T utf8 $man_path
        done
      '';

      # tell mandoc the paths containing man pages
      profileRelativeSessionVariables."MANPATH" = map (path: "/${path}") cfg.manPath;
    };
  };
}
