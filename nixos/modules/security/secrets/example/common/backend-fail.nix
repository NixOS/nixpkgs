# An example backend that fails on getting/setting. Used for testing the
# error-recovery behaviour of the CLI.
let
  fail =
    pkgs:
    pkgs.writeScript "fail" ''
      #!/bin/sh
      echo "Automatically failing" 1>&2
      exit 1
    '';

  noop =
    pkgs:
    pkgs.writeScript "noop" ''
      #!/bin/sh
    '';
in
{
  config.secrets.backends.store.fail = {
    get = fail;
    set = fail;
    list = noop;
  };
}
