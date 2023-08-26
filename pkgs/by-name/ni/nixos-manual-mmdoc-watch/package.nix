{ writeScriptBin, python3, inotify-tools } :

writeScriptBin "nixos-manual-mmdoc-watch" ''
  killbg() {
    for p in "''${pids[@]}" ; do
      kill "$p";
    done
  }
  trap killbg EXIT

  nix-build . -A nixos-manual-mmdoc

  pids=()
  ${python3}/bin/python -m http.server --directory ./result &
  pids+=($!)
  trap exit SIGINT

  while ${inotify-tools}/bin/inotifywait -e modify -e create doc pkgs/by-name/ni/nixos-manual-mmdoc
  do
    nix-build . -A nixos-manual-mmdoc
  done
''
