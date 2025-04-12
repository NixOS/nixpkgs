# The test template is taken from the `./keymap.nix`
{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  readyFile = "/tmp/readerReady";
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

  mkKeyboardTest =
    name:
    { default, test }:
    with pkgs.lib;
    makeTest {
      inherit name;

      nodes.machine = {
        services.keyd = {
          enable = true;
          keyboards = { inherit default; };
        };
      };

      testScript = ''
        import shlex

        machine.wait_for_unit("keyd.service")

        def run_test_case(cmd, test_case_name, inputs, expected):
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
                # wait for reader to be ready
                machine.wait_for_file("${readyFile}")
                # send all keys
                for key in inputs:
                    machine.send_key(key)
                # wait for result and check
                machine.wait_for_file("${resultFile}")
                machine.succeed("grep -q 'PASS:' ${resultFile}")
        test = ${builtins.toJSON test}
        run_test_case("openvt -sw --", "${name}", test["press"], test["expect"])
      '';
    };

in
pkgs.lib.mapAttrs mkKeyboardTest {
  swap-ab_and_ctrl-as-shift = {
    test.press = [
      "a"
      "ctrl-b"
      "c"
      "alt_r-h"
    ];
    test.expect = [
      "b"
      "A"
      "c"
      "q"
    ];

    default = {
      settings.main = {
        "a" = "b";
        "b" = "a";
        "control" = "oneshot(shift)";
        "rightalt" = "layer(rightalt)";
      };
      extraConfig = ''
        [rightalt:G]
        h = q
      '';
    };
  };
}
