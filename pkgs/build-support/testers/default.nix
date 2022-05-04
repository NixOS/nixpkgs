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

  testGraphical =
    { package
    , command ? "${package.meta.mainProgram or package.pname or package.name}"
    , expectedText ? "File" # Very very common in menu bars.
    }: nixosTest ({ pkgs, ... }: {
      name = "${package.name}-test-graphical";

      machine = { ... }: {
        imports = [ ../../nixos/tests/common/wayland-cage.nix ];
        environment.systemPackages = [ package ];
        services.cage.program = "${package}/bin/${command}";
      };

      enableOCR = expectedText != null;

      testScript = ''
        @polling_condition
        def cage_running():
          machine.require_unit_state("cage-tty1.service", "active")


        machine.wait_for_unit("cage-tty1.service")
        with cage_running:
            machine.wait_until_succeeds("pgrep -f ${command}")
            machine.wait_for_text("${expectedText}", verbose=True)
            machine.screenshot("screen")
      '';
    });
}
