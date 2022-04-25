import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "noto-fonts";
  meta = {
    maintainers = with lib.maintainers; [ nickcao midchildan ];
  };

  nodes.machine = {
    imports = [ ./common/x11.nix ];
    environment.systemPackages = [ pkgs.gnome.gedit ];
    fonts = {
      enableDefaultFonts = false;
      fonts = with pkgs;[
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
      ];
      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  testScript =
    # extracted from http://www.clagnut.com/blog/2380/
    # emoji are from Unicode 14 (latest standard)
    let testText = builtins.toFile "test.txt" ''
      the quick brown fox jumps over the lazy dog
      視野無限廣，窗外有藍天
      Eĥoŝanĝo ĉiuĵaŭde.
      いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす
      다람쥐 헌 쳇바퀴에 타고파
      中国智造，慧及全球
      🫠🫣🫱🏻‍🫲🏿
    ''; in
    ''
      machine.wait_for_x()
      machine.succeed("gedit ${testText} >&2 &")
      machine.wait_for_window(".* - gedit")
      machine.sleep(10)
      machine.screenshot("screen")
    '';
})
