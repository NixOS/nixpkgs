{ lib, writeShellScript }: let
  output = "hello";
in (writeShellScript "test-script" ''
  echo ${lib.escapeShellArg output}
'').overrideAttrs (old: {
  installCheckPhase = old.installCheckPhase or "" + ''
    expected=${lib.escapeShellArg output}
    got=$("$target")
    if [[ "$got" != "$expected" ]]; then
      echo "wrong output: expected $expected, got $got"
      exit 1
    fi
  '';
})
