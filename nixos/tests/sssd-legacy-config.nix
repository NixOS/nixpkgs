import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "sssd-legacy-config";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ bbigras ];
    };
    nodes.machine.services.sssd = {
      enable = true;
      config = # ini
        ''
          [sssd]
          services = nss, pam
          domains = shadowutils

          [nss]

          [pam]

          [domain/shadowutils]
          id_provider = proxy
          proxy_lib_name = files
          auth_provider = proxy
          proxy_pam_target = sssd-shadowutils
          proxy_fast_alias = True
        '';
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("sssd.service")
      machine.succeed("sssctl config-check")
    '';
  }
)
