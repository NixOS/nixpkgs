import ./make-test-python.nix ({ lib, ... }:
{
  name = "fontconfig-default-fonts";

  meta.maintainers = with lib.maintainers; [
    jtojnar
  ];

  nodes.machine = { config, pkgs, ... }: {
    fonts.enableDefaultFonts = true; # Background fonts
    fonts.fonts = with pkgs; [
      noto-fonts-emoji
      cantarell-fonts
      twitter-color-emoji
      source-code-pro
      gentium
    ];
    fonts.fontconfig.defaultFonts = {
      serif = [ "Gentium Plus" ];
      sansSerif = [ "Cantarell" ];
      monospace = [ "Source Code Pro" ];
      emoji = [ "Twitter Color Emoji" ];
    };
  };

  testScript = ''
    machine.succeed("fc-match serif | grep '\"Gentium Plus\"'")
    machine.succeed("fc-match sans-serif | grep '\"Cantarell\"'")
    machine.succeed("fc-match monospace | grep '\"Source Code Pro\"'")
    machine.succeed("fc-match emoji | grep '\"Twitter Color Emoji\"'")
  '';
})
