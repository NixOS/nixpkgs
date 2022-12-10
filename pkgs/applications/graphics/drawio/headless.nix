{ lib, writeTextFile, runtimeShell, drawio, xvfb-run }:

writeTextFile {
  name = "${drawio.pname}-headless-${drawio.version}";

  executable = true;
  destination = "/bin/drawio";
  text = ''
    #!${runtimeShell}

    # Electron really wants a configuration directory to not die with:
    # "Error: Failed to get 'appData' path"
    # so we give it some temp dir as XDG_CONFIG_HOME
    tmpdir=$(mktemp -d)

    function cleanup {
      rm -rf "$tmpdir"
    }
    trap cleanup EXIT

    # Drawio needs to run in a virtual X session, because Electron
    # refuses to work and dies with an unhelpful error message otherwise:
    # "The futex facility returned an unexpected error code."
    XDG_CONFIG_HOME="$tmpdir" ${xvfb-run}/bin/xvfb-run ${drawio}/bin/drawio $@
  '';

  meta = with lib; {
    description = "xvfb wrapper around drawio";
    longDescription = ''
      A wrapper around drawio for running in headless environments.
      Runs drawio under xvfb-run, with configuration going to a temporary
      directory.
    '';
    maintainers = with maintainers; [ qyliss tfc ];
  };
}
