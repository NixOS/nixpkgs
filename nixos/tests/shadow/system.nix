{ pkgs, ... }:
let
  # Create a Python environment for the controller with all necessary test framework dependencies
  controllerPython = pkgs.python3.withPackages (ps: [
    ps.flaky
    ps.jc
    ps.passlib
    ps.pytest
    ps.pytest-mh
    ps.pytest-ticket
  ]);

  shadowHostName = "shadowhost";
in
{
  name = "shadow-system-tests";

  meta.maintainers = with pkgs.lib.maintainers; [ joaosreis ];

  nodes = {
    # The target host: runs sshd, has shadow and other test dependencies installed, mutable users, and some specific settings to match the expectations of the test suite
    shadowhost =
      { pkgs, ... }:
      {
        networking.hostName = shadowHostName;
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "yes";
            PasswordAuthentication = false;
          };
        };

        users.mutableUsers = true;

        environment.systemPackages = with pkgs; [
          shadow
          expect
          vim
        ];

        users.defaultUserShell = "/bin/sh";

        security.loginDefs.settings = {
          PASS_MAX_DAYS = 99999;
          PASS_MIN_DAYS = 0;
          PASS_WARN_AGE = 7;
          USERGROUPS_ENAB = "yes";
          CREATE_HOME = "yes";
          UID_MIN = 1001;
          GID_MIN = 1001;
        };

        security.pam.services = {
          newusers.text = ''
            auth    required    pam_permit.so
            account required    pam_permit.so
            password required   pam_permit.so
            session required    pam_permit.so
          '';
        };

        services.envfs.enable = true;
      };

    # The controller: runs pytest-mh against the shadow host
    controller =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          controllerPython
          pkgs.openssh
        ];
      };

  };

  testScript = ''
    import textwrap

    start_all()

    # ------------------------------------------------------------------
    # 1. Generate an SSH keypair on the controller and authorise it
    #    on the shadow host
    # ------------------------------------------------------------------
    controller.succeed("mkdir -p /root/.ssh && chmod 700 /root/.ssh")
    controller.succeed(
        "ssh-keygen -t ed25519 -N \'\' -f /root/.ssh/id_ed25519 2>&1"
    )
    pub_key = controller.succeed("cat /root/.ssh/id_ed25519.pub").strip()

    # Inject the generated public key into the shadow host at runtime
    shadowhost.succeed("mkdir -p /root/.ssh && chmod 700 /root/.ssh")
    shadowhost.succeed(
        f"echo '{pub_key}' >> /root/.ssh/authorized_keys && "
        "chmod 600 /root/.ssh/authorized_keys"
    )

    # ------------------------------------------------------------------
    # 2. Make sure the shadow host has a writable /etc/login.defs,
    #    since the test framework expects to be able to write to it.
    # ------------------------------------------------------------------
    shadowhost.succeed(
        "cp --remove-destination $(readlink -f /etc/login.defs) /etc/login.defs && "
        "chmod 644 /etc/login.defs"
    )

    # ------------------------------------------------------------------
    # 3. Copy the upstream test suite onto the controller
    # ------------------------------------------------------------------
    controller.succeed(
        "cp -r ${pkgs.shadow.passthru.testFramework} /root/shadow-tests && "
        "chmod -R u+w /root/shadow-tests"
    )

    # ------------------------------------------------------------------
    # 4. Write the mhc.yaml topology config
    #    This tells pytest-mh where the shadow host is and which role
    #    it plays. The hostname must match the NixOS node name.
    # ------------------------------------------------------------------
    controller.succeed(textwrap.dedent("""
        cat > /root/shadow-tests/mhc.yaml << 'EOF'
        domains:
          - id: shadow
            hosts:
              - hostname: ${shadowHostName}
                role: shadow
                ssh:
                  user: root
                  private_key: /root/.ssh/id_ed25519
        EOF
    """))


    # ------------------------------------------------------------------
    # 5. Run the upstream pytest-mh test suite from the controller
    # ------------------------------------------------------------------
    shadowhost.wait_for_unit("sshd.service")
    # gpasswd tests are disabled, since they rely on specific behavior of the gpasswd command that is not applicable to NixOS
    controller.succeed(
        "cd /root/shadow-tests && "
        "${controllerPython}/bin/pytest "
        "--mh-config=mhc.yaml "
        "--deselect=tests/test_gpasswd.py "
        "-v tests/"
    )
  '';
}
