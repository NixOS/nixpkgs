{ lib
, buildPackages
, hare
, runCommandNoCC
, stdenv
, writeText
}:
let
  inherit (stdenv.hostPlatform.uname) processor;
  inherit (stdenv.hostPlatform) emulator;
  mainDotHare = writeText "main.ha" ''
    use fmt;
    use os;
    export fn main() void = {
        const machine = os::machine();
        if (machine == "${processor}") {
            fmt::println("os::machine() matches ${processor}")!;
        } else {
            fmt::fatalf("os::machine() does not match ${processor}: {}", machine);
        };
    };
  '';
in
runCommandNoCC "${hare.pname}-cross-compilation-test" { meta.timeout = 60; } ''
  HARECACHE="$(mktemp -d --tmpdir harecache.XXXXXXXX)"
  export HARECACHE
  outbin="test-${processor}"
  ${lib.getExe hare} build -q -a "${processor}" -o "$outbin" ${mainDotHare}
  ${emulator buildPackages} "./$outbin"
  : 1>$out
''
