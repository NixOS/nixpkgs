{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.users.defaults;
in {
  options.users.defaults = {
    editor = mkOption {
      type = types.editorPackage;
      default = pkgs.nano;
      defaultText = literalExample "pkgs.nano";
      example = literalExample "pkgs.kakoune";
      description = ''
        The package to use as the default editor.

        To change the <varname>$EDITOR</varname> variable, set
        the editorCommand passthru of the package. For example:

        <programlisting>
        users.defaults.editor = pkgs.vim // { editorCommand = "gvim -f"; };
        </programlisting>
      '';
    };

    pager = mkOption {
      type = types.pagerPackage;
      default = pkgs.less;
      defaultText = literalExample "pkgs.less";
      example = literalExample "pkgs.most";
      description = ''
        The package to use as the default pager.

        To change the <varname>$PAGER</varname> variable, set
        the pagerCommand passthru of the package. For example:

        <programlisting>
        users.defaults.pager = pkgs.less // { pagerCommand = "less -R"; };
        </programlisting>
      '';
    };
  };

  config = {
    environment.systemPackages = [ cfg.editor cfg.pager ];

    environment.variables = {
      EDITOR = mkDefault cfg.editor.editorCommand;
      PAGER = mkDefault cfg.pager.pagerCommand;
    };
  };
}
