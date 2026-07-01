{ pkgs, ... }:
let
  # Pull the system test suite directly from the shadow source tree
  shadowSrc = pkgs.shadow.src;

  # Create derivations for pytest-mh and pytest-ticket, which are upstream test framework dependencies
  pytest-mh = pkgs.python3Packages.buildPythonPackage rec {
    pname = "pytest-mh";
    version = "1.0.21";
    src = pkgs.fetchFromGitHub {
      owner = "next-actions";
      repo = "pytest-mh";
      rev = version;
      sha256 = "sha256-mDMRSAaI6qvAl6Ib1NNEPmTuf0won6ytWVDADG6IqUw=";
    };
    doCheck = false;
    pyproject = true;
    build-system = with pkgs.python3Packages; [
      hatchling
      hatch-vcs
      hatch-requirements-txt
    ];
    dependencies = with pkgs.python3Packages; [
      ansible-pylibssh
      colorama
      pytest
      pyyaml
    ];
    postInstall = ''
      rm -f $out/lib/python*/site-packages/requirements.txt
    '';
  };

  pytest-ticket = pkgs.python3Packages.buildPythonPackage {
    pname = "pytest-ticket";
    version = "0.1.1";
    src = pkgs.fetchFromGitHub {
      owner = "next-actions";
      repo = "pytest-ticket";
      rev = "9f77e77d99ee25a65cad2ab07815884bf7271552";
      sha256 = "sha256-oR0kwrr8nnrVpWc27pOtM+6K00llTQGRTpvKmOyCIYY=";
    };
    doCheck = false;
    pyproject = true;
    build-system = with pkgs.python3Packages; [
      hatchling
      hatch-vcs
      hatch-requirements-txt
    ];
    dependencies = with pkgs.python3Packages; [
      pytest
    ];
    postInstall = ''
      rm -f $out/lib/python*/site-packages/requirements.txt
    '';
  };

  # Create a derivation for the shadow test framework
  shadowTestFramework = pkgs.python3Packages.buildPythonPackage {
    pname = "shadow-test-framework";
    version = pkgs.shadow.version;
    src = "${shadowSrc}/tests/system";
    format = "other";
    installPhase = ''
      cp -r . $out/
    '';
    dontBuild = true;
    postPatch = ''
      # Replace the gshadow existence check in the test framework with a more NixOS-friendly one, since NixOS does not have /etc/gshadow as a regular file
      substituteInPlace framework/hosts/shadow.py \
        --replace-fail 'getent gshadow > /dev/null 2>&1' 'test -f /etc/gshadow'

      # Remove the backup entry for gshadow, since it's not being used in the tests running on NixOS
      sed -i '/{"origin": "\/etc\/gshadow", "backup": "gshadow"}/d' framework/hosts/shadow.py

      # Replace the Debian-specific check in the useradd test with a NixOS-specific one
      substituteInPlace tests/test_useradd.py \
        --replace-fail 'if "Debian" in shadow.host.distro_name:' 'if "NixOS" in shadow.host.distro_name:'

      # Backport upstream fixes for the tests not yet included in the released version
      substituteInPlace tests/test_useradd.py \
        --replace-fail 'assert passwd_entry.uid == 1000' 'assert passwd_entry.uid == 1001' \
        --replace-fail 'assert id_entry.user.id == 1000' 'assert id_entry.user.id == 1001' \
        --replace-fail 'assert group_entry.gid == 1000' 'assert group_entry.gid == 1001' \
        --replace-fail 'assert passwd_entry.gid == 1000' 'assert passwd_entry.gid == 1001'
      substituteInPlace tests/test_usermod.py \
        --replace-fail 'assert passwd_entry.uid == 1000' 'assert passwd_entry.uid == 1001' \
        --replace-fail 'assert group_entry.gid == 1000' 'assert group_entry.gid == 1001'
      substituteInPlace tests/test_groupadd.py \
        --replace-fail 'assert group_entry.gid == 1000' 'assert group_entry.gid == 1001'
      substituteInPlace tests/test_newgrp.py \
        --replace-fail 'assert gid == 1001' 'assert gid == 1002'
    '';
  };

  # Create a Python environment for the controller with all necessary test framework dependencies, including the shadow test framework itself
  controllerPython = pkgs.python3.withPackages (ps: [
    ps.flaky
    ps.jc
    ps.pytest
    pytest-mh
    pytest-ticket
    shadowTestFramework
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
          vim
          expect
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
        "cp -r ${shadowTestFramework} /root/shadow-tests && "
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
