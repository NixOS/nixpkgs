# pkgs.runInMkShell {#sec-pkgs-runInMkShell}

`pkgs.runInMkShell` is a function that generates a wrapper script that
receives the command to be run as arguments and then run it inside a special
environment created with [`mkShell`](#sec-pkgs-mkShell).

It's basically like the `--run` flag of `nix-shell`, but using Nix expressions.

`nix-shell` works by setting some specific environment variables and then
source the setup script from stdenv.

The setup script from stdenv implements primitives such as the phase and hook
system that allows modular logic for derivations.

Because `nix-shell` is coupled with this behaviour that is implemented in
nixpkgs it isn't used in the "nix3 cli" (in this case, `nix develop` and `nix
shell`) that uses a much simpler but incomplete approach: just add the
derivations bin folder to $PATH.

To have the `nix-shell` behaviour in a `nix3` utility one must wrap a list of
programs in `mkShell`, which is what `nix-shell` does under the hood
automatically.

And this function modularizes it to a wrapper script. It creates a script that
runs the command passed as arguments in an environment built the same way as
nix-shell does.

The generated script can also be embedded in other scripts using the `source`
command.

## Usage {#sec-pkgs-runInMkShell-usage}

```nix
{ pkgs ? import <nixpkgs> { } }:
pkgs.runInMkShell {
  shell = pkgs.bash + "/bin/bash"

  name = "demo-environment";

  drv = pkgs.mkShell {
    buildInputs = with pkgs.python3Packages; [ numpy pandas ];
  };

  prelude = ''
    echo Hello world
  '';
};
```

## Attributes {#sec-pkgs-runInMkShell-attributes}
* `shell` (default: `${pkgs.bash} + "/bin/bash"`): Which shell to use as the
 script shebang.
* `name` (default: `"${drv.name}-wrapper"`): Name of the derivation for the
 script.
* `drv`: Result of [`mkShell`](#sec-pkgs-mkShell). Can be also only the
 attrset of the arguments for `mkShell` or the list of the packages.
* `prelude`: Code to be pasted just before the script runs the command
 passed with the arguments. It has access to the arguments using the
 standard variables such as `$@`.

## Function result {#sec-pkgs-runInMkShell-result}

This function will always generate a folder with a executable script in bin.

The absolute path of the executable script can always be obtained by using
`lib.getExe`.

This executable script will accept a command as the arguments and will setup an
environment like `nix-shell` does, then run the code in `prelude`, and lastly
the command passed as parameter.

Running it without parameters does nothing by default.

Sourcing the script will run everything but the command that would be passed as
argument.

Let the output of the code [right above](#sec-pkgs-runInMkShell-usage) be
defined as `$script`, an example usage of the script can be:

```shell
$script python -c 'import numpy as np; import pandas as pd; print(np, pd)'
```

In this case, the script will print "Hello world" because of the prelude, and
the representations of `np` and `pd` because of Python.

More usage examples can be found in the function tests at
`pkgs/build-support/runinmkshell/tests.nix`. All the tests expose the script
generated in the test.
