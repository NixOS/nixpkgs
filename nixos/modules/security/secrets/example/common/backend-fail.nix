# An example backend that fails on getting/setting. Used for testing the
# error-recovery behaviour of the CLI.
let
  fail =
    pkgs:
    pkgs.writeShellScript "fail" ''
      echo "Automatically failing" 1>&2
      exit 1
    '';

  noop = pkgs: pkgs.writeShellScript "noop" "";
in
{
  config.secrets.backends.store.fail = {
    get = fail;
    set = fail;
    list = noop;
  };
}
