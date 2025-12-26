{ lib, ... }:
{
  name = "fontconfig-bitmap-fonts";

  nodes.machine =
    { config, pkgs, ... }:
    {
      fonts.packages = [
        pkgs.terminus_font
      ];
      fonts.fontconfig.allowBitmaps = true;
    };

  testScript = ''
    machine.succeed("fc-list | grep Terminus")
  '';
}
