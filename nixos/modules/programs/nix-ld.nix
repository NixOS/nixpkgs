{ pkgs, lib, config, ... }:
{
  meta.maintainers = [ lib.maintainers.mic92 ];
  options = {
    programs.nix-ld.enable = lib.mkEnableOption ''nix-ld, Documentation: <link xlink:href="https://github.com/Mic92/nix-ld"/>'';
  };
  config = lib.mkIf config.programs.nix-ld.enable {
    systemd.tmpfiles.packages = [ pkgs.nix-ld ];
  };
}
