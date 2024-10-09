{
  makeWrapper,
  runCommand,
  writeShellScript,
}:

name: extras: makeWrapperArgs:
runCommand name
  {
    inherit makeWrapperArgs;

    nativeBuildInputs = [ makeWrapper ] ++ extras;

    payload = writeShellScript "execute" ''
      exec "$@"
    '';

    dontWrapGApps = true;
    dontWrapQtApps = true;

  }
  ''
    [[ -v gappsWrapperArgs ]] && makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    [[ -v qtWrapperArgs ]] &&  makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    mkdir -p $out/bin
    echo makeWrapper args:
    _makeWrapperArgs=()
    for arg in "''${makeWrapperArgs[@]}"; do
      if [ ! -z "$arg" ]; then
        echo arg: $arg
        _makeWrapperArgs+=("$arg")
      fi
    done
    makeWrapper $payload $out/bin/$name "''${_makeWrapperArgs[@]}"
  ''
