# An example non-interactive prompt backend which merely reads the files from a
# static directory.
{ config, lib, ... }:
let
  cfg = config.secrets.settings.prompt.test;

  mkScript =
    name: text: pkgs:
    pkgs.lib.getExe (
      pkgs.writeShellApplication {
        inherit name text;
        runtimeInputs = [ pkgs.coreutils ];
        checkPhase = "";
      }
    );
in
{
  options.secrets.settings.prompt.test.inputDirectory = lib.mkOption {
    type = lib.types.oneOf [
      lib.types.str
      lib.types.path
    ];
    description = ''
      The directory where the plain-text prompt inputs should be read from.
    '';
  };

  config.secrets.backends.prompt.test.ask = mkScript "prompt" ''
    cp ${cfg.inputDirectory}/"$1"/"$2" "$out"
  '';
}
