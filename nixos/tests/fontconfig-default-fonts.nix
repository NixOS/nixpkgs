{ lib, ... }:
{
  name = "fontconfig-default-fonts";

  meta.maintainers = with lib.maintainers; [
    jtojnar
  ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      fonts.enableDefaultPackages = true; # Background fonts
      fonts.packages = with pkgs; [
        noto-fonts-color-emoji
        cantarell-fonts
        twitter-color-emoji
        source-code-pro
        gentium
      ];
      fonts.fontconfig.defaultFonts = {
        serif = [ "Gentium" ];
        sansSerif = [ "Cantarell" ];
        monospace = [ "Source Code Pro" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };

  testScript = ''
    machine.succeed("fc-match serif | grep '\"Gentium\"'")
    machine.succeed("fc-match sans-serif | grep '\"Cantarell\"'")
    machine.succeed("fc-match monospace | grep '\"Source Code Pro\"'")
    machine.succeed("fc-match emoji | grep '\"Twitter Color Emoji\"'")
  '';
}
