{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

let
  testReader = pkgs.writeScript "test-input-reader" ''
    #!${pkgs.stdenv.shell}
    readInput() {
      touch /tmp/reader.ready
      echo "Waiting for '$1' to be typed"
      read -r -n1 c
      if [ "$c" = "$2" ]; then
        echo "SUCCESS: Got back '$c' as expected."
        echo 0 >&2
      else
        echo "FAIL: Expected '$2' but got '$c' instead."
        echo 1 >&2
      fi
    }

    main() {
      error=0
      while [ $# -gt 0 ]; do
        ret="$((readInput "$2" "$3" | systemd-cat -t "$1") 2>&1)"
        if [ $ret -ne 0 ]; then error=1; fi
        shift 3
      done
      return $error
    }

    main "$@"; echo -n $? > /tmp/reader.exit
  '';

  mkReaderInput = testname: { qwerty, expect }: with pkgs.lib; let
    lq = length qwerty;
    le = length expect;
    msg = "`qwerty' (${lq}) and `expect' (${le}) lists"
        + " need to be of the same length!";
    result = flatten (zipListsWith (a: b: [testname a b]) qwerty expect);
  in if lq != le then throw msg else result;

  mkKeyboardTest = layout: { extraConfig ? {}, tests }: with pkgs.lib; let
    readerInput = flatten (mapAttrsToList mkReaderInput tests);
    perlStr = val: "'${escape ["'" "\\"] val}'";
    perlReaderInput = concatMapStringsSep ", " perlStr readerInput;
  in makeTest {
    name = "keymap-${layout}";

    machine.i18n.consoleKeyMap = mkOverride 900 layout;
    machine.services.xserver.layout = mkOverride 900 layout;
    machine.imports = [ ./common/x11.nix extraConfig ];

    testScript = ''
      sub waitCatAndDelete ($) {
        return $machine->succeed(
          "for i in \$(seq 600); do if [ -e '$_[0]' ]; then ".
          "cat '$_[0]' && rm -f '$_[0]' && exit 0; ".
          "fi; sleep 0.1; done; echo timed out after 60 seconds >&2; exit 1"
        );
      };

      sub mkTest ($$) {
        my ($desc, $cmd) = @_;

        my @testdata = (${perlReaderInput});
        my $shellTestdata = join ' ', map { "'".s/'/'\\'''/gr."'" } @testdata;

        subtest $desc, sub {
          $machine->succeed("$cmd ${testReader} $shellTestdata &");
          while (my ($testname, $qwerty, $expect) = splice(@testdata, 0, 3)) {
            waitCatAndDelete "/tmp/reader.ready";
            $machine->sendKeys($qwerty);
          };
          my $exitcode = waitCatAndDelete "/tmp/reader.exit";
          die "tests for $desc failed" if $exitcode ne 0;
        };
      }

      $machine->waitForX;

      mkTest "VT keymap", "openvt -sw --";
      mkTest "Xorg keymap", "DISPLAY=:0 xterm -fullscreen -e";
    '';
  };

in pkgs.lib.mapAttrs mkKeyboardTest {
  azerty = {
    tests = {
      azqw.qwerty = [ "q" "w" ];
      azqw.expect = [ "a" "z" ];
      altgr.qwerty = [ "alt_r-2" "alt_r-3" "alt_r-4" "alt_r-5" "alt_r-6" ];
      altgr.expect = [ "~"       "#"       "{"       "["       "|"       ];
    };

    extraConfig.i18n.consoleKeyMap = "azerty/fr";
    extraConfig.services.xserver.layout = "fr";
  };

  colemak = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "r" "s" "t" "n" "e" "i" "o"         ];
    };

    extraConfig.i18n.consoleKeyMap = "en-latin9";
    extraConfig.services.xserver.layout = "us";
    extraConfig.services.xserver.xkbVariant = "colemak";
  };

  dvorak = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "o" "e" "u" "h" "t" "n" "s"         ];
      symbols.qwerty = [ "q" "w" "e" "minus" "equal" ];
      symbols.expect = [ "'" "," "." "["     "]"     ];
    };
  };

  dvp = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "o" "e" "u" "h" "t" "n" "s"         ];
      numbers.qwerty = map (x: "shift-${x}")
                       [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "minus" ];
      numbers.expect = [ "%" "7" "5" "3" "1" "9" "0" "2" "4" "6" "8" ];
      symbols.qwerty = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "minus" ];
      symbols.expect = [ "&" "[" "{" "}" "(" "=" "*" ")" "+" "]" "!" ];
    };

    extraConfig.services.xserver.layout = "us";
    extraConfig.services.xserver.xkbVariant = "dvp";
  };

  neo = {
    tests = {
      layer1.qwerty = [ "f"           "j"                     ];
      layer1.expect = [ "e"           "n"                     ];
      layer2.qwerty = [ "shift-f"     "shift-j"     "shift-6" ];
      layer2.expect = [ "E"           "N"           "$"       ];
      layer3.qwerty = [ "caps_lock-d" "caps_lock-f"           ];
      layer3.expect = [ "{"           "}"                     ];
    };

    extraConfig.services.xserver.layout = "de";
    extraConfig.services.xserver.xkbVariant = "neo";
  };

  qwertz = {
    tests = {
      zy.qwerty = [ "z" "y" ];
      zy.expect = [ "y" "z" ];
      altgr.qwerty = map (x: "alt_r-${x}")
                     [ "q" "less" "7" "8" "9" "0" ];
      altgr.expect = [ "@" "|"    "{" "[" "]" "}" ];
    };

    extraConfig.i18n.consoleKeyMap = "de";
    extraConfig.services.xserver.layout = "de";
  };
}
