{
  latestKernel,
  lib,
  ...
}:

{
  name = "systemd-analyze";
  meta.maintainers = with lib.maintainers; [ raskin ];

  _module.args.latestKernel = lib.mkDefault false;

  nodes.machine =
    { pkgs, lib, ... }:
    {
      boot.kernelPackages = lib.mkIf latestKernel pkgs.linuxPackages_latest;
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # We create a special output directory to copy it as a whole
    with subtest("Prepare output dir"):
        machine.succeed("mkdir systemd-analyze")


    # Save the output into a file with given name inside the common
    # output directory
    def run_systemd_analyze(args, name):
        tgt_dir = "systemd-analyze"
        machine.succeed(
            "systemd-analyze {} > {}/{} 2> {}/{}.err".format(
                " ".join(args), tgt_dir, name, tgt_dir, name
            )
        )


    with subtest("Print statistics"):
        run_systemd_analyze(["blame"], "blame.txt")
        run_systemd_analyze(["critical-chain"], "critical-chain.txt")
        run_systemd_analyze(["dot"], "dependencies.dot")
        run_systemd_analyze(["plot"], "systemd-analyze.svg")

    # We copy the main graph into the $out (toplevel), and we also copy
    # the entire output directory with additional data
    with subtest("Copying the resulting data into $out"):
        machine.copy_from_vm("systemd-analyze/", "")
        machine.copy_from_vm("systemd-analyze/systemd-analyze.svg", "")
  '';
}
