{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  readyFile  = "/tmp/readerReady";
  resultFile = "/tmp/readerResult";

  testReader = pkgs.writeScript "test-input-reader" ''
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


  mkKeyboardTest = layout: { extraConfig ? {}, tests }: with pkgs.lib; makeTest {
    name = "keymap-${layout}";

    nodes.machine.console.keyMap = mkOverride 900 layout;
    nodes.machine.services.xserver.desktopManager.xterm.enable = false;
    nodes.machine.services.xserver.xkb.layout = mkOverride 900 layout;
    nodes.machine.imports = [ ./common/x11.nix extraConfig ];

    testScript = ''
      import json
      import shlex


      def run_test_case(cmd, xorg_keymap, test_case_name, inputs, expected):
          with subtest(test_case_name):
              assert len(inputs) == len(expected)
              machine.execute("rm -f ${readyFile} ${resultFile}")

              # set up process that expects all the keys to be entered
              machine.succeed(
                  "{} {} {} {} >&2 &".format(
                      cmd,
                      "${testReader}",
                      len(inputs),
                      shlex.quote("".join(expected)),
                  )
              )

              if xorg_keymap:
                  # make sure the xterm window is open and has focus
                  machine.wait_for_window("testterm")
                  machine.wait_until_succeeds(
                      "${pkgs.xdotool}/bin/xdotool search --sync --onlyvisible "
                      "--class testterm windowfocus --sync"
                  )

              # wait for reader to be ready
              machine.wait_for_file("${readyFile}")

              # send all keys
              for key in inputs:
                  machine.send_key(key)

              # wait for result and check
              machine.wait_for_file("${resultFile}")
              machine.succeed("grep -q 'PASS:' ${resultFile}")


      with open("${pkgs.writeText "tests.json" (builtins.toJSON tests)}") as json_file:
          tests = json.load(json_file)

      # These environments used to run in the opposite order, causing the
      # following error at openvt startup.
      #
      # openvt: Couldn't deallocate console 1
      #
      # This error did not appear in successful runs.
      # I don't know the exact cause, but I it seems that openvt and X are
      # fighting over the virtual terminal. This does not appear to be a problem
      # when the X test runs first.
      keymap_environments = {
          "Xorg Keymap": "DISPLAY=:0 xterm -title testterm -class testterm -fullscreen -e",
          "VT Keymap": "openvt -sw --",
      }

      machine.wait_for_x()

      for keymap_env_name, command in keymap_environments.items():
          with subtest(keymap_env_name):
              for test_case_name, test_data in tests.items():
                  run_test_case(
                      command,
                      False,
                      test_case_name,
                      test_data["qwerty"],
                      test_data["expect"],
                  )
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

    extraConfig.console.keyMap = "fr";
    extraConfig.services.xserver.xkb.layout = "fr";
  };

  bone = {
    tests = {
      layer1.qwerty = [ "f"           "j"                     ];
      layer1.expect = [ "e"           "n"                     ];
      layer2.qwerty = [ "shift-f"     "shift-j"     "shift-6" ];
      layer2.expect = [ "E"           "N"           "$"       ];
      layer3.qwerty = [ "caps_lock-d" "caps_lock-f"           ];
      layer3.expect = [ "{"           "}"                     ];
    };

    extraConfig.console.keyMap = "bone";
    extraConfig.services.xserver.xkb.layout = "de";
    extraConfig.services.xserver.xkb.variant = "bone";
  };

  colemak = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "r" "s" "t" "n" "e" "i" "o"         ];
    };

    extraConfig.console.keyMap = "colemak";
    extraConfig.services.xserver.xkb.layout = "us";
    extraConfig.services.xserver.xkb.variant = "colemak";
  };

  dvorak = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "o" "e" "u" "h" "t" "n" "s"         ];
      symbols.qwerty = [ "q" "w" "e" "minus" "equal" ];
      symbols.expect = [ "'" "," "." "["     "]"     ];
    };

    extraConfig.console.keyMap = "dvorak";
    extraConfig.services.xserver.xkb.layout = "us";
    extraConfig.services.xserver.xkb.variant = "dvorak";
  };

  dvorak-programmer = {
    tests = {
      homerow.qwerty = [ "a" "s" "d" "f" "j" "k" "l" "semicolon" ];
      homerow.expect = [ "a" "o" "e" "u" "h" "t" "n" "s"         ];
      numbers.qwerty = map (x: "shift-${x}")
                       [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "minus" ];
      numbers.expect = [ "%" "7" "5" "3" "1" "9" "0" "2" "4" "6" "8" ];
      symbols.qwerty = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "minus" ];
      symbols.expect = [ "&" "[" "{" "}" "(" "=" "*" ")" "+" "]" "!" ];
    };

    extraConfig.console.keyMap = "dvorak-programmer";
    extraConfig.services.xserver.xkb.layout = "us";
    extraConfig.services.xserver.xkb.variant = "dvp";
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

    extraConfig.console.keyMap = "neo";
    extraConfig.services.xserver.xkb.layout = "de";
    extraConfig.services.xserver.xkb.variant = "neo";
  };

  qwertz = {
    tests = {
      zy.qwerty = [ "z" "y" ];
      zy.expect = [ "y" "z" ];
      altgr.qwerty = map (x: "alt_r-${x}")
                     [ "q" "less" "7" "8" "9" "0" ];
      altgr.expect = [ "@" "|"    "{" "[" "]" "}" ];
    };

    extraConfig.console.keyMap = "de";
    extraConfig.services.xserver.xkb.layout = "de";
  };

  custom = {
    tests = {
      us.qwerty = [ "a" "b" "g" "d" "z" "shift-2" "shift-3" ];
      us.expect = [ "a" "b" "g" "d" "z" "@" "#" ];
      greek.qwerty = map (x: "alt_r-${x}")
                     [ "a" "b" "g" "d" "z" ];
      greek.expect = [ "α" "β" "γ" "δ" "ζ" ];
    };

    extraConfig.console.useXkbConfig = true;
    extraConfig.services.xserver.xkb.layout = "us-greek";
    extraConfig.services.xserver.extraLayouts.us-greek =
      { description = "US layout with alt-gr greek";
        languages   = [ "eng" ];
        symbolsFile = pkgs.writeText "us-greek" ''
          xkb_symbols "us-greek"
          {
            include "us(basic)"
            include "level3(ralt_switch)"
            key <LatA> { [ a, A, Greek_alpha ] };
            key <LatB> { [ b, B, Greek_beta  ] };
            key <LatG> { [ g, G, Greek_gamma ] };
            key <LatD> { [ d, D, Greek_delta ] };
            key <LatZ> { [ z, Z, Greek_zeta  ] };
          };
        '';
      };
  };
}
