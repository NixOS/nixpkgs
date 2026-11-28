{ lib, ... }:
{
  name = "ccache";
  meta.maintainers = with lib.maintainers; [ rhendric ];
  node.pkgsReadOnly = false;

  nodes.machine =
    { pkgs, ... }:
    let
      # This test configures inih to be built with ccache. We have to
      # realize inih on the guest so that the host building this test
      # doesn't have to have ccache enabled, but we have to instantiate
      # inih on the host because the Nixpkgs overlay that causes ccache to
      # be used is only in effect during evaluation of the guest's config.
      # https://github.com/NixOS/nix/issues/7330 makes this a huge pain; it
      # seems impossible for the guest to take a dependency on the derivation
      # file and its closure without also building the outputs on the host,
      # which we can't do.
      #
      # We work around this by (exportDrv) copying the derivation file into
      # something Nix doesn't think is a derivation anymore, exposing that to
      # the guest, and then (import_drv) copying it back into the store in
      # the guest as something that looks like a derivation file again. I
      # expect this could (and should!) all be replaced with
      # builtins.unsafeDiscardOutputDependency if 7330 got a fix.
      exportDrv =
        d:
        pkgs.runCommand "drv-for-${d.name}" {
          drvText = addAllDrvOutputDependencies (builtins.readFile d.drvPath);
          passAsFile = [ "drvText" ];
        } "cp $drvTextPath $out";

      # Make every dependency "derivation deep". A generalization of
      # builtins.addDrvOutputDependencies.
      addAllDrvOutputDependencies =
        s:
        lib.pipe (builtins.getContext s) [
          (lib.filterAttrs (k: _: lib.hasSuffix ".drv" k))
          (builtins.mapAttrs (_: _: { allOutputs = true; }))
          (builtins.appendContext s)
        ];

      drvs = builtins.mapAttrs (_: exportDrv) (
        with pkgs;
        {
          inherit inih;
          ccacheConfigDump = runCommand "ccache-config-dump.txt" {
            nativeBuildInputs = [ ccache ];
          } "ccache -p > $out";
        }
      );
    in
    {
      imports = [ ../modules/profiles/minimal.nix ];
      nix = {
        enable = true;
        settings.substitute = false;
      };
      programs.ccache = {
        enable = true;
        packageNames = [ "inih" ];
        # (We previously tested hello instead, but hello is slow to build!)
      };
      system.extraDependencies = builtins.attrValues drvs;
      passthru = drvs;

      specialisation.extraSettings.configuration = {
        programs.ccache.settings = {
          max_size = "10GiB";
          sloppiness = [ "time_macros" ];
        };
        system.extraDependencies = lib.mkForce [ ];
      };
    };

  testScript =
    { nodes, ... }:
    ''
      import re
      start_all()
      machine.wait_for_unit("multi-user.target")

      def import_drv(exported_file):
        drv_file_name = f"{re.sub("/nix/store/[^-]*-drv-for-", "", exported_file)}.drv"
        return machine.succeed(f"cp {exported_file} {drv_file_name} && nix-store --add {drv_file_name}").strip()

      ccache_config_dump_drv = import_drv("${nodes.machine.passthru.ccacheConfigDump}")
      inih_drv = import_drv("${nodes.machine.passthru.inih}")

      def test_ccache_config(**assertions):
        dump_file = machine.succeed(f"nix-store --realise {ccache_config_dump_drv}").strip()
        for key, expected in assertions.items():
          out = machine.succeed(f"grep ' {key} =' {dump_file}").strip()
          assert out.endswith(f" {expected}"), f"{out} (expected {repr(expected)})"
        machine.succeed(f"nix-store --delete {dump_file}")

      # host configuration: test that ccache is configured, as seen from inside
      # a build sandbox
      test_ccache_config(cache_dir="/var/cache/ccache", sloppiness="random_seed", umask="007")

      machine.succeed("${nodes.machine.system.build.toplevel}/specialisation/extraSettings/bin/switch-to-configuration test")
      test_ccache_config(max_size="10.0 GiB", sloppiness="random_seed, time_macros")
      machine.succeed("${nodes.machine.system.build.toplevel}/bin/switch-to-configuration test")

      # target configuration: test that inih uses ccache
      stats_before = machine.succeed("nix-ccache --show-stats")
      inih = machine.succeed(f"nix-store --realise {inih_drv} | grep -ve '-dev$'").strip()
      machine.succeed(f"[[ -f {inih}/lib/libinih.so ]]")
      stats_after = machine.succeed("nix-ccache --show-stats")
      assert stats_before != stats_after, "CCache stats did not change"

      machine.shutdown()
    '';
}
