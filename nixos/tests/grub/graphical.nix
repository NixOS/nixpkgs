{ lib, ... }:
{
  name = "grub-graphical";

  meta = with lib.maintainers; {
    maintainers = [
      tomfitzhenry
      rnhmjoj
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    let
      # GRUB only draws a background image when it is in graphical gfxterm
      # mode. Bake a marker string into the splash so the OCR check below can
      # only succeed when gfxterm actually rendered it; a silent fallback to
      # text mode would show the plain menu without this image (and its text).
      #
      # The image must be an 8-bit sRGB PNG, otherwise GRUB's png module fails
      # to load it and silently falls back to its default (non-graphical) menu.
      splash = pkgs.runCommand "grub-gfxterm-splash.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
        magick -size 1024x768 xc:'#2d2d2d' \
          -font ${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf \
          -gravity south -pointsize 48 -fill white \
          -annotate +0+150 'GFXTERMOK' \
          -depth 8 -type TrueColor PNG24:$out
      '';
    in
    {
      virtualisation.useBootLoader = true;

      # Leave the menu up long enough for OCR to catch it; we boot early with a
      # keypress once it has, so this does not slow the test down.
      boot.loader.timeout = 30;
      boot.loader.grub = {
        enable = true;
        splashImage = splash;
      };
    };

  enableOCR = true;

  testScript = ''
    machine.start()

    with subtest("GRUB renders its menu graphically (gfxterm), showing the splash"):
        # The marker text lives inside the background image, so reading it back
        # proves GRUB displayed the image rather than falling back to text mode.
        machine.wait_for_text("GFXTERMOK")
        machine.screenshot("grub_gfxterm")

    with subtest("Machine boots into NixOS from GRUB"):
        machine.send_key("ret")
        machine.wait_for_unit("multi-user.target")
  '';
}
