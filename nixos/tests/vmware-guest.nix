import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "vmware-guest";
    meta.maintainers = with lib.maintainers; [ kjeremy ];

    nodes = {
      headless =
        {
          config,
          options,
          pkgs,
          ...
        }:
        {
          virtualisation.vmware.guest = {
            enable = true;
            headless = true;
          };

          environment.variables = {
            EXPECTED_VMWARE_TOOLS_PATH = pkgs.open-vm-tools-headless;
            VMWARE_TOOLS_PATH = config.virtualisation.vmware.guest.package;
          };
        };

      full =
        {
          config,
          options,
          pkgs,
          ...
        }:
        {
          virtualisation.vmware.guest = {
            enable = true;
            headless = false;
          };

          environment.variables = {
            EXPECTED_VMWARE_TOOLS_PATH = pkgs.open-vm-tools;
            VMWARE_TOOLS_PATH = config.virtualisation.vmware.guest.package;
          };
        };

      custom =
        {
          config,
          options,
          pkgs,
          ...
        }:
        {
          virtualisation.vmware.guest = {
            enable = true;
            headless = true;

            # Override the package with non-default
            package = pkgs.open-vm-tools;
          };

          environment.variables = {
            EXPECTED_VMWARE_TOOLS_PATH = pkgs.open-vm-tools;
            VMWARE_TOOLS_PATH = config.virtualisation.vmware.guest.package;
          };
        };
    };

    testScript = ''
      start_all()

      headless.wait_for_unit("default.target")
      headless.succeed("[ $EXPECTED_VMWARE_TOOLS_PATH = $VMWARE_TOOLS_PATH ]")

      full.wait_for_unit("default.target")
      full.succeed("[ $EXPECTED_VMWARE_TOOLS_PATH = $VMWARE_TOOLS_PATH ]")

      custom.wait_for_unit("default.target")
      custom.succeed("[ $EXPECTED_VMWARE_TOOLS_PATH = $VMWARE_TOOLS_PATH ]")
    '';
  }
)
