{ pkgs, lib, ... }:
{
  name = "aesmd";
  meta = {
    maintainers = with lib.maintainers; [
      trundle
      veehaitch
    ];
  };

  nodes.machine =
    { lib, ... }:
    {
      services.aesmd = {
        enable = true;
        settings = {
          defaultQuotingType = "ecdsa_256";
          proxyType = "direct";
          whitelistUrl = "http://nixos.org";
        };
      };

      # Should have access to the AESM socket
      users.users."sgxtest" = {
        isNormalUser = true;
        extraGroups = [ "sgx" ];
      };

      # Should NOT have access to the AESM socket
      users.users."nosgxtest".isNormalUser = true;

      # We don't have a real SGX machine in NixOS tests
      systemd.services.aesmd.unitConfig.AssertPathExists = lib.mkForce [ ];

      specialisation = {
        withQuoteProvider.configuration =
          { ... }:
          {
            services.aesmd = {
              quoteProviderLibrary = pkgs.sgx-azure-dcap-client;
              environment = {
                AZDCAP_DEBUG_LOG_LEVEL = "INFO";
              };
            };
          };
      };
    };

  testScript =
    { nodes, ... }:
    let
      specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
    in
    ''
      def get_aesmd_pid():
        status, main_pid = machine.systemctl("show --property MainPID --value aesmd.service")
        assert status == 0, "Could not get MainPID of aesmd.service"
        return main_pid.strip()

      with subtest("aesmd.service starts"):
        machine.wait_for_unit("aesmd.service")

      main_pid = get_aesmd_pid()

      with subtest("aesmd.service runtime directory permissions"):
        runtime_dir = "/run/aesmd";
        res = machine.succeed(f"stat -c '%a %U %G' {runtime_dir}").strip()
        assert "750 aesmd sgx" == res, f"{runtime_dir} does not have the expected permissions: {res}"

      with subtest("aesm.socket available on host"):
        socket_path = "/var/run/aesmd/aesm.socket"
        machine.wait_until_succeeds(f"test -S {socket_path}")
        machine.succeed(f"test 777 -eq $(stat -c '%a' {socket_path})")
        for op in [ "-r", "-w", "-x" ]:
          machine.succeed(f"sudo -u sgxtest test {op} {socket_path}")
          machine.fail(f"sudo -u nosgxtest test {op} {socket_path}")

      with subtest("Copies white_list_cert_to_be_verify.bin"):
        whitelist_path = "/var/opt/aesmd/data/white_list_cert_to_be_verify.bin"
        whitelist_perms = machine.succeed(
          f"nsenter -m -t {main_pid} ${pkgs.coreutils}/bin/stat -c '%a' {whitelist_path}"
        ).strip()
        assert "644" == whitelist_perms, f"white_list_cert_to_be_verify.bin has permissions {whitelist_perms}"

      with subtest("Writes and binds aesm.conf in service namespace"):
        aesmd_config = machine.succeed(f"nsenter -m -t {main_pid} ${pkgs.coreutils}/bin/cat /etc/aesmd.conf")

        assert aesmd_config == "whitelist url = http://nixos.org\nproxy type = direct\ndefault quoting type = ecdsa_256\n", "aesmd.conf differs"

      with subtest("aesmd.service without quote provider library has correct LD_LIBRARY_PATH"):
        status, environment = machine.systemctl("show --property Environment --value aesmd.service")
        assert status == 0, "Could not get Environment of aesmd.service"
        env_by_name = dict(entry.split("=", 1) for entry in environment.split())
        assert not env_by_name["LD_LIBRARY_PATH"], "LD_LIBRARY_PATH is not empty"

      with subtest("aesmd.service with quote provider library starts"):
        machine.succeed('${specialisations}/withQuoteProvider/bin/switch-to-configuration test')
        machine.wait_for_unit("aesmd.service")

      main_pid = get_aesmd_pid()

      with subtest("aesmd.service with quote provider library has correct LD_LIBRARY_PATH"):
        ld_library_path = machine.succeed(f"xargs -0 -L1 -a /proc/{main_pid}/environ | grep LD_LIBRARY_PATH")
        assert ld_library_path.startswith("LD_LIBRARY_PATH=${pkgs.sgx-azure-dcap-client}/lib:"), \
          "LD_LIBRARY_PATH is not set to the configured quote provider library"

      with subtest("aesmd.service with quote provider library has set AZDCAP_DEBUG_LOG_LEVEL"):
        azdcp_debug_log_level = machine.succeed(f"xargs -0 -L1 -a /proc/{main_pid}/environ | grep AZDCAP_DEBUG_LOG_LEVEL")
        assert azdcp_debug_log_level == "AZDCAP_DEBUG_LOG_LEVEL=INFO\n", "AZDCAP_DEBUG_LOG_LEVEL is not set to INFO"
    '';
}
