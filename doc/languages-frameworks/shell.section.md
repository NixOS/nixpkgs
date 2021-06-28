# Shell Packages
Many packages provide some shell script that gives extra functionality if `source`d from the shell.
Those need to have extra outputs called `${shell}_${phase}` where:
* shell refers to the specific shell it needs to be included (either bash, fish or zsh).
* phase refers to when the file will be sourced, this can be one of:
* * `interactiveShellInit`,if it needs to be included in the interactive shell initialization
* * `shellInit` if the code needs to be included in the normal shell initiaalization
* * `loginShellInit` if the code is meant to be included in the login shell initialization.
* * `promptInit` if the codeis needed to initialize the shell prompt.

Then you need to put the script to be sourced in such output (not a subdirectory).

Then, nixos users can add those packages to their shell initialization by adding them to `environment.shellPkgs` option.
