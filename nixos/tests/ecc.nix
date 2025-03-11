import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    # Well, we _can_ cross-compile from Linux :)
    compileResult = pkgs.runCommand "empty.bpf.o" { } ''
      touch empty.bpf.c
      ${pkgs.ecc}/bin/ecc-rs empty.bpf.c
      cp empty.bpf.o $out
    '';
  in
  {
    name = "ecc-rs";

    meta.maintainers = with lib.maintainers; [ oluceps ];

    nodes.machine = { };

    testScript = ''
      start_all()
      machine.succeed("cat ${compileResult} >out")
      machine.succeed("shutdown")
    '';
  }
)
