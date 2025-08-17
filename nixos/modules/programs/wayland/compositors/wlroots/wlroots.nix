{
  lib,
  pkgs,
}:

{
  programs.obs-studio.plugins = lib.mkAfter (
    with pkgs.obs-studio-plugins;
    [
      wlrobs
    ]
  );
}
