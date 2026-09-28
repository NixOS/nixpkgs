# An example non-interactive prompt backend which merely reads the files from a
# static directory.
{ config, lib, ... }:
let
  cfg = config.secrets.settings.prompt.test;
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

  config.secrets.backends.prompt.test.ask =
    pkgs:
    pkgs.writeShellScript "prompt-test" ''
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
      cp ${cfg.inputDirectory}/"$1"/"$2" "$out"
    '';
}
