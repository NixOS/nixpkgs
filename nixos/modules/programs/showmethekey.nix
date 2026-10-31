{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.showmethekey;
in
{
  options.programs.showmethekey = {
    enable = lib.mkEnableOption "showmethekey, an on-screen key caster";

    useSetuidWrapper = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to wrap showmethekey-cli with setuid root privileges
        to avoid using pkexec.

        Warning: This allows any local process under your user account
        to execute showmethekey-cli and capture raw input events.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (
        if cfg.useSetuidWrapper then
          pkgs.showmethekey.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace showmethekey-gtk/smtk-keys-emitter.c \
                --replace-fail 'PKEXEC_PATH,' '"/run/wrappers/bin/showmethekey-cli",' \
                --replace-fail 'PACKAGE_BINDIR "/showmethekey-cli",' ""
            '';
          })
        else
          pkgs.showmethekey
      )
    ];

    security.wrappers = lib.mkIf cfg.useSetuidWrapper {
      showmethekey-cli = {
        owner = "root";
        group = "root";
        source = lib.getExe' pkgs.showmethekey "showmethekey-cli";
        setuid = true;
      };
    };
  };
}
