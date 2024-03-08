{ lib
, xvfb-run
, tvbrowser
, runCommand
, writeShellApplication
, xorg
}:

let
  testScript = writeShellApplication {
    name = "tvbrowser-test-script";
    runtimeInputs = [ xorg.xwininfo tvbrowser ];
    text = ''
      function find_tvbrowser_windows {
        for window_name in java tvbrowser-TVBrowser 'Setup assistant' ; do
          grep -q "$window_name" "$1"  ||  return 1
        done
      }
      tvbrowser &
      for _ in {0..900} ; do
        xwininfo -root -tree  \
            | sed 's/.*0x[0-9a-f]* \"\([^\"]*\)\".*/\1/; t; d'  \
            | tee window-names
        echo
        if find_tvbrowser_windows window-names ; then
          break
        fi
        sleep 1
      done
      find_tvbrowser_windows window-names
    '';
  };
in
runCommand
"tvbrowser-test"
{ buildInputs = [ xvfb-run ]; }
''
  HOME=$PWD xvfb-run ${lib.getExe testScript}
  touch ${placeholder "out"}
''
