{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };

let
  readyFile  = "/tmp/readerReady";
  resultFile = "/tmp/readerResult";

  testReader = pkgs.writeScript "test-input-reader" ''
    #!${pkgs.stdenv.shell}
    rm -f ${resultFile} ${resultFile}.tmp
    logger "testReader: START: Waiting for $1 characters, expecting '$2'."
    touch ${readyFile}
    read -r -N $1 chars
    rm -f ${readyFile}

    if [ "$chars" == "$2" ]; then
      logger -s "testReader: PASS: Got '$2' as expected." 2>${resultFile}.tmp
    else
      logger -s "testReader: FAIL: Expected '$2' but got '$chars'." 2>${resultFile}.tmp
    fi
    # rename after the file is written to prevent a race condition
    mv  ${resultFile}.tmp ${resultFile}
  '';


  mkKeyboardTest = layout: { extraConfig ? {}, tests }: with pkgs.lib; let
    combinedTests = foldAttrs (acc: val: acc ++ val) [] (builtins.attrValues tests);
    perlStr = val: "'${escape ["'" "\\"] val}'";
    lq = length combinedTests.qwerty;
    le = length combinedTests.expect;
    msg = "length mismatch between qwerty (${toString lq}) and expect (${toString le}) lists!";
    send   = concatMapStringsSep ", " perlStr combinedTests.qwerty;
    expect = if (lq == le) then concatStrings combinedTests.expect else throw msg;

  in makeTest {
    name = "keymap-${layout}";

    machine.services.xserver.desktopManager.xterm.enable = false;
    machine.i18n.consoleKeyMap = mkOverride 900 layout;
    machine.services.xserver.layout = mkOverride 900 layout;
    machine.imports = [ ./common/x11.nix extraConfig ];

    testScript = ''

      sub mkTest ($$) {
        my ($desc, $cmd) = @_;

        subtest $desc, sub {
          # prepare and start testReader
          $machine->execute("rm -f ${readyFile} ${resultFile}");
          $machine->succeed("$cmd ${testReader} ${toString le} ".q(${escapeShellArg expect} & ));

          if ($desc eq "Xorg keymap") {
            # make sure the xterm window is open and has focus
            $machine->waitForWindow(qr/testterm/);
            $machine->waitUntilSucceeds("${pkgs.xdotool}/bin/xdotool search --sync --onlyvisible --class testterm windowfocus --sync");
          }

          # wait for reader to be ready
          $machine->waitForFile("${readyFile}");
          $machine->sleep(1);

          # send all keys
          foreach ((${send})) { $machine->sendKeys($_); };

          # wait for result and check
          $machine->waitForFile("${resultFile}");
          $machine->succeed("grep -q 'PASS:' ${resultFile}");
        };
      };

      $machine->waitForX;

      mkTest "VT keymap", "openvt -sw --";
      mkTest "Xorg keymap", "DISPLAY=:0 xterm -title testterm -class testterm -fullscreen -e";
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

    extraConfig.i18n.consoleKeyMap = "colemak/colemak";
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
