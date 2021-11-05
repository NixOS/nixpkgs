import ./make-test-python.nix ({ pkgs, ... } : {
  name = "rasdaemon";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ evils ];
  };

  machine = { pkgs, ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    hardware.rasdaemon = {
      enable = true;
      # should be enabled by default, just making sure
      record = true;
      # nonsense label
      labels = ''
        vendor: none
          product: none
          model: none
            DIMM_0: 0.0.0;
      '';
    };
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      # confirm rasdaemon is running and has a valid database
      # some disk errors detected in qemu for some reason ¯\_(ツ)_/¯
      machine.succeed("ras-mc-ctl --errors | tee /dev/stderr | grep -q 'No .* errors.'")
      # confirm the supplied labels text made it into the system
      machine.succeed("grep -q 'vendor: none' /etc/ras/dimm_labels.d/labels >&2")
      machine.shutdown()
    '';
})
