{
  lib,
  hare,
  runCommandNoCC,
  writeText,
}:
let
  archs = lib.concatStringsSep " " (
    builtins.map (lib.removeSuffix "-linux") (
      builtins.filter (lib.hasSuffix "-linux") hare.meta.platforms
    )
  );
  mainDotHare = writeText "main.ha" ''
    export fn main() void = void;
  '';
in
runCommandNoCC "${hare.pname}-cross-compilation-test" { nativeBuildInputs = [ hare ]; } ''
  HARECACHE="$(mktemp -d)"
  export HARECACHE
  readonly binprefix="bin"
  for a in ${archs}; do
    outbin="$binprefix-$a"
    set -x
    hare build -o "$outbin" -q -R -a "$a" ${mainDotHare}
    set +x
    printf -- 'Built "%s" target\n' "$a"
  done

  printf -- 'Generated binary file: %s\n' "$binprefix-"*

  : 1>$out
''
