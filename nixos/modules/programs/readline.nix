{ config, lib, ... }:

let
  cfg = config.programs.readline;

  mkSetVariableStr =
    n: v:
    let
      mkValueStr =
        v:
        if v == true then
          "on"
        else if v == false then
          "off"
        else if lib.isInt v then
          toString v
        else if lib.isString v then
          v
        else
          abort "values ${lib.toPretty v} is of unsupported type";
    in
    "set ${n} ${mkValueStr v}";

  mkBindingStr =
    k: v:
    let
      isKeynameNotKeyseq =
        k:
        builtins.elem (builtins.head (lib.splitString "-" (lib.toLower k))) [
          "control"
          "meta"
        ];
    in
    if isKeynameNotKeyseq k then "${k}: ${v}" else ''"${k}": ${v}'';

  finalConfig =
    let
      configStr = lib.concatStringsSep "\n" (
        lib.mapAttrsToList mkSetVariableStr cfg.variables ++ lib.mapAttrsToList mkBindingStr cfg.bindings
      );
    in
    ''
      ${lib.optionalString cfg.rhel rhelConfig}
      ${configStr}
      ${cfg.extraConfig}
    '';

  rhelConfig = ''
    # inputrc borrowed from CentOS (RHEL).

    set bell-style none

    set meta-flag on
    set input-meta on
    set convert-meta off
    set output-meta on
    set colored-stats on

    $if mode=emacs

    # for linux console and RH/Debian xterm
    "\e[1~": beginning-of-line
    "\e[4~": end-of-line
    "\e[5~": beginning-of-history
    "\e[6~": end-of-history
    "\e[3~": delete-char
    "\e[2~": quoted-insert
    "\e[5C": forward-word
    "\e[5D": backward-word
    "\e[1;5C": forward-word
    "\e[1;5D": backward-word

    # for rxvt
    "\e[8~": end-of-line

    # for non RH/Debian xterm, can't hurt for RH/DEbian xterm
    "\eOH": beginning-of-line
    "\eOF": end-of-line

    # for freebsd console
    "\e[H": beginning-of-line
    "\e[F": end-of-line
    $endif
  '';
in
{
  options.programs.readline = {
    enable = lib.mkEnableOption "readline" // {
      # defaults to one to preserve backwards compatibility
      default = true;
    };

    bindings = lib.mkOption {
      default = { };
      type = with lib.types; attrsOf str;
      example = lib.literalExpression ''
        { "\\C-h" = "backward-kill-word"; }
      '';
      description = "Readline bindings.";
    };

    variables = lib.mkOption {
      type = with lib.types; attrsOf (either str (either int bool));
      default = { };
      example = {
        expand-tilde = true;
      };
      description = ''
        Readline customization variable assignments.
      '';
    };

    rhel = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Use borrowed from CentOS config.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Configuration lines appended unchanged to the end of the
        {file}`/etc/inputrc` file.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc.inputrc.text = finalConfig;
  };

  meta.maintainers = with lib.maintainers; [ wozrer ];
}
