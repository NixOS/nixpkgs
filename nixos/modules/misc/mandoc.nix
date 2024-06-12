{ config, lib, pkgs, ... }:

let
  makewhatis = "${lib.getBin cfg.package}/bin/makewhatis";

  cfg = config.documentation.man.mandoc;

  toMandocOutput = output: (
    lib.mapAttrsToList
      (
        name: value:
          if lib.isString value || lib.isPath value then "output ${name} ${value}"
          else if lib.isInt value then "output ${name} ${builtins.toString value}"
          else if lib.isBool value then lib.optionalString value "output ${name}"
          else if value == null then ""
          else throw "Unrecognized value type ${builtins.typeOf value} of key ${name} in mandoc output settings"
      )
      output
  );

  makeLeadingSlashes = map (path: if builtins.substring 0 1 path != "/" then "/${path}" else path);
in
{
  meta.maintainers = [ lib.maintainers.sternenseemann ];

  options = {
    documentation.man.mandoc = {
      enable = lib.mkEnableOption "mandoc as the default man page viewer";

      manPath = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ "share/man" ];
        example = lib.literalExpression "[ \"share/man\" \"share/man/fr\" ]";
        apply = makeLeadingSlashes;
        description = ''
          Change the paths included in the MANPATH environment variable,
          i. e. the directories where {manpage}`man(1)`
          looks for section-specific directories of man pages.
          You only need to change this setting if you want extra man pages
          (e. g. in non-english languages). All values must be strings that
          are a valid path from the target prefix (without including it).
          The first value given takes priority. Note that this will not
          add manpath directives to {manpage}`man.conf(5)`.
        '';
      };

      cachePath = lib.mkOption {
        type = with lib.types; listOf str;
        default = cfg.manPath;
        defaultText = lib.literalExpression "config.documentation.man.mandoc.manPath";
        example = lib.literalExpression "[ \"share/man\" \"share/man/fr\" ]";
        apply = makeLeadingSlashes;
        description = ''
          Change the paths where mandoc {manpage}`makewhatis(8)`generates the
          manual page index caches. {option}`documentation.man.generateCaches`
          should be enabled to allow cache generation. This list should only
          include the paths to manpages installed in the system configuration,
          i. e. /run/current-system/sw/share/man. {manpage}`makewhatis(8)`
          creates a database in each directory using the files
          `mansection/[arch/]title.section` and `catsection/[arch/]title.0`
          in it. If a directory contains no manual pages, no database is
          created in that directory.
          This option only needs to be set manually if extra paths should be
          indexed or {option}`documentation.man.manPath` contains paths that
          can't be indexed.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.mandoc;
        defaultText = lib.literalExpression "pkgs.mandoc";
        description = ''
          The `mandoc` derivation to use. Useful to override
          configuration options used for the package.
        '';
      };

      settings = lib.mkOption {
        description = "Configuration for {manpage}`man.conf(5)`";
        default = { };
        type = lib.types.submodule {
          options = {
            manpath = lib.mkOption {
              type = with lib.types; listOf str;
              default = [ ];
              example = lib.literalExpression "[ \"/run/current-system/sw/share/man\" ]";
              description = ''
                Override the default search path for {manpage}`man(1)`,
                {manpage}`apropos(1)`, and {manpage}`makewhatis(8)`. It can be
                used multiple times to specify multiple paths, with the order
                determining the manual page search order.
                This is not recommended in favor of
                {option}`documentation.man.mandoc.manPath`, but if it's needed to
                specify the manpath in this way, set
                {option}`documentation.man.mandoc.manPath` to an empty list (`[]`).
              '';
            };
            output.fragment = lib.mkEnableOption ''
              Omit the <!DOCTYPE> declaration and the <html>, <head>, and <body>
              elements and only emit the subtree below the <body> element in HTML
              output of {manpage}`mandoc(1)`. The style argument will be ignored.
              This is useful when embedding manual content within existing documents.
            '';
            output.includes = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = lib.literalExpression "../src/%I.html";
              description = ''
                A string of relative path used as a template for the output path of
                linked header files (usually via the In macro) in HTML output.
                Instances of `%I` are replaced with the include filename. The
                default is not to present a hyperlink.
              '';
            };
            output.indent = lib.mkOption {
              type = with lib.types; nullOr int;
              default = null;
              description = ''
                Number of blank characters at the left margin for normal text,
                default of `5` for {manpage}`mdoc(7)` and `7` for
                {manpage}`man(7)`. Increasing this is not recommended; it may
                result in degraded formatting, for example overfull lines or ugly
                line breaks. When output is to a pager on a terminal that is less
                than 66 columns wide, the default is reduced to three columns.
              '';
            };
            output.man = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = lib.literalExpression "../html%S/%N.%S.html";
              description = ''
                A template for linked manuals (usually via the Xr macro) in HTML
                output. Instances of ‘%N’ and ‘%S’ are replaced with the linked
                manual's name and section, respectively. If no section is included,
                section 1 is assumed. The default is not to present a hyperlink.
                If two formats are given and a file %N.%S exists in the current
                directory, the first format is used; otherwise, the second format is used.
              '';
            };
            output.paper = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              description = ''
                This option is for generating PostScript and PDF output. The paper
                size name may be one of `a3`, `a4`, `a5`, `legal`, or `letter`.
                You may also manually specify dimensions as `NNxNN`, width by
                height in millimetres. If an unknown value is encountered, letter
                is used. Output pages default to letter sized and are rendered in
                the Times font family, 11-point. Margins are calculated as 1/9 the
                page length and width. Line-height is 1.4m.
              '';
            };
            output.style = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Path to the file used for an external style-sheet. This must be a
                valid absolute or relative URI.
              '';
            };
            output.toc = lib.mkEnableOption ''
              In HTML output of {manpage}`mandoc(1)`, If an input file contains
              at least two non-standard sections, print a table of contents near
              the beginning of the output.
            '';
            output.width = lib.mkOption {
              type = with lib.types; nullOr int;
              default = null;
              description = ''
                The ASCII and UTF-8 output width, default is `78`. When output is a
                pager on a terminal that is less than 79 columns wide, the
                default is reduced to one less than the terminal width. In any case,
                lines that are output in literal mode are never wrapped and may
                exceed the output width.
              '';
            };
          };
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration to write to {manpage}`man.conf(5)`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];

      etc."man.conf".text = lib.concatStringsSep "\n" (
        (map (path: "manpath ${path}") cfg.settings.manpath)
        ++ (toMandocOutput cfg.settings.output)
        ++ [ cfg.extraConfig ]
      );

      # create mandoc.db for whatis(1), apropos(1) and man(1) -k
      # TODO(@sternenseemman): fix symlinked directories not getting indexed,
      # see: https://inbox.vuxu.org/mandoc-tech/20210906171231.GF83680@athene.usta.de/T/#e85f773c1781e3fef85562b2794f9cad7b2909a3c
      extraSetup = lib.mkIf config.documentation.man.generateCaches ''
        for man_path in ${lib.concatMapStringsSep " " (path: "$out" + lib.escapeShellArg path) cfg.cachePath}
        do
          [[ -d "$man_path" ]] && ${makewhatis} -T utf8 $man_path
        done
      '';

      # tell mandoc the paths containing man pages
      profileRelativeSessionVariables."MANPATH" = lib.mkIf (cfg.manPath != [ ]) cfg.manPath;
    };
  };
}
