{
  writeShellApplication,
  coreutils,
  gnused,
  gnugrep,
  which,

  # apparmor deps
  apparmor-parser,
  apparmor-bin-utils,
  libapparmor,
}:
writeShellApplication {
  name = "apparmor-teardown";
  runtimeInputs = [
    apparmor-parser
    apparmor-bin-utils
    coreutils
    gnused
    gnugrep
    which
  ];

  text = ''
    set +e # the imported script tries to `read` an empty line
    # shellcheck source=/dev/null
    . ${apparmor-parser}/lib/apparmor/rc.apparmor.functions
    remove_profiles
    exit 0
  '';

  inherit (libapparmor) meta;
}
