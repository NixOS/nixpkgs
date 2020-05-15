import ./make-test-python.nix ({ pkgs, ... }:

let
  riscvPkgs = import ../.. { crossSystem = pkgs.stdenv.lib.systems.examples.riscv64-embedded; };
in
{
  name = "spike";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ blitz ]; };

  machine = { pkgs, lib, ... }: {
    environment.systemPackages = [ pkgs.spike riscvPkgs.riscv-pk riscvPkgs.hello ];
  };

  # Run the RISC-V hello applications using the proxy kernel on the
  # Spike emulator and see whether we get the expected output.
  testScript =
    ''
      machine.wait_for_unit("multi-user.target")
      output = machine.succeed("spike -m64 $(which pk) $(which hello)")
      assert output == "Hello, world!\n"
    '';
})
