{ runInMkShell
, mkShell
, runCommand
, lib
, pkgs
, writeText
, writeShellScriptBin
}:

let
  mkTest = {
      # passed directly as name parameter to runInMkShell
      name ? "test"
    , # rest of flags for runInMkShell
      args ? {}
    , # can be either a shell script as string with $script or a list of arguments to $script
      command ? []
    , # passed directly as drv parameter to runInMkShell
      drv
    , touchOut ? false
  }:
  let
    # generated wrapper script
    script = runInMkShell (args // { inherit drv name; });

    payload = if lib.isList command then "$script ${lib.escapeShellArgs command}" else toString command;
  in runCommand "runInMkShell-${name}" {
    passthru = { inherit script; };
  } ''
    script=${lib.getExe script}

    ${payload}

    ${lib.optionalString touchOut "touch $out"}
  '';

in lib.recurseIntoAttrs (lib.mapAttrs (k: v: mkTest (v // { name = k; })) {

  identity = {  # as basic as possible test
    command = [ "true" ];
    drv = [];
    touchOut = true;
  };
  test-the-test = { # not using the list form because it automatically creates $out
    command = ''
      $script test-payload 2 ${placeholder "out"}
    '';
    drv = [ # this way we can confirm that the wrapper is receiving the args and reacting properly
      (writeShellScriptBin "test-payload" ''
        [ $1 -eq 2 ]
        echo Inner script called
        touch $2
      '')
    ];
  };

  bc = { # note that you need to pass the command to run inside the wrapper context
    command = "echo 2+2 | $script bc > $out";
    drv = [ pkgs.bc ];
  };

  python-numpy = { # note that in nix-shell python is propagated from the library
    command = [ "python" (writeText "script.py" ''
      import numpy as np
      from sys import argv

      d = np.ones(10, dtype='int')

      with open(argv[1], "w") as f:
        print(d, file=f)
    '') (placeholder "out") ];
    drv = [ pkgs.python3Packages.numpy ];
  };

  bring-variables = { # extra variables can be passed as the other mkShell parameters
    command = ''
      theVar=$($script sh -c 'echo $theVar')
      [ $theVar == 2 ] && touch $out
    '';
    drv = {
      theVar = 2;
    };
  };

  bring-variables-long = { # the same previous test can also be written using the long form
    command = ''
      theVar=$($script sh -c 'echo $theVar')
      [ $theVar == 2 ] && touch $out
    '';
    drv = mkShell {
      theVar = 2;
    };
  };

  hook-simple = { # the shell primitives available in mkDerivation are also available
    command = [ "eval" ''
      outDir=${placeholder "out"}
      runHook mkShellTestingHook
    ''];
    drv = {
      mkShellTestingHook = ''
        touch $outDir
      '';
    };
  };

})
