{ lib, ... }:
{
  name = "fontconfig-default-fonts";

  meta.maintainers = with lib.maintainers; [
    jtojnar
  ];

  containers.machine =
    { config, pkgs, ... }:
    {
      fonts.enableDefaultPackages = true; # Background fonts
      fonts.packages = with pkgs; [
        noto-fonts-color-emoji
        twitter-color-emoji
        source-code-pro
        gentium
      ];
      fonts.fontconfig.defaultFonts = {
        serif = [ "Gentium" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "Source Code Pro" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };

  testScript = ''
    machine.succeed("fc-match serif | grep '\"Gentium\"'")
    machine.succeed("fc-match sans-serif | grep '\"DejaVu Sans\"'")
    machine.succeed("fc-match monospace | grep '\"Source Code Pro\"'")
    machine.succeed("fc-match emoji | grep '\"Twitter Color Emoji\"'")
  '';
}
