{ pkgs, lib, callPackage, runCommand }:
# Documentation is in doc/builders/testers.chapter.md
{
  testEqualDerivation = callPackage ./test-equal-derivation.nix { };

  testVersion =
    { package,
      command ? "${package.meta.mainProgram or package.pname or package.name} --version",
      version ? package.version,
    }: runCommand "${package.name}-test-version" { nativeBuildInputs = [ package ]; meta.timeout = 60; } ''
      if output=$(${command} 2>&1); then
        grep -Fw "${version}" - <<< "$output"
        touch $out
      else
        echo "$output" >&2 && exit 1
      fi
    '';
}
