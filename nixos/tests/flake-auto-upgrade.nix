import ./make-test-python.nix (
  { lib, pkgs, ... }:

  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
    inherit (lib) getExe;

    alicePassword = "password";
    aliceUsername = "alice";
    repohome = "/var/www/git/";
    nixOverlay = (
      _: prev: {
        # we have to override nix because we can't build anything
        # without a substituter for the bootstrapping seed
        nix =
          (pkgs.writeShellScriptBin "nix" ''
            case $@ in
              *\ flake\ *)
                echo "newline" >> ./fakeFlake
                ${getExe pkgs.git} add ./fakeFlake
                ${getExe pkgs.git} commit -m "Add fake flake"
                ;;
              *\ build\ *attr1*)
                if [ ! -f failFile ]
                then
                   touch ./result1
                   exit 0
                else
                   exit 1
                fi
                ;;
              *\ build\ *attr2*)
                exit 1
                ;;
              *\ build\ *attr3*)
                touch ./result3
                ;;
              *\ build\ *attr4*)
                touch ./result4
                ;;
            esac
          '').overrideAttrs
            (_: {
              version = "2.2";
            });

      }
    );
  in
  {
    name = "flake-auto-upgrade";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ StillerHarpo ];
    };

    nodes = {
      builder =
        { ... }:
        {
          services.flakeAutoUpgrade = {
            http = {
              remote = "http://gitweb";
              credentials = {
                user = aliceUsername;
                passwordFile = pkgs.writeText "password" alicePassword;
              };
              updateBranch = "update";
              buildAttributes = [
                {
                  attr = "attr1";
                  onFail = [
                    {
                      attr = "attr2";
                      onFail = [ "attr3" ];
                    }
                  ];
                }
                "attr4"
              ];
              gitCryptKeyFile = ./gitCryptKey;
              failLogInCommitMsg = true;
            };
            ssh = {
              remote = "root@gitweb:${repohome}";
              ssh = {
                hostKey = "gitweb " + snakeOilPublicKey;
                key = snakeOilPrivateKey;
              };
              updateBranch = "update";
              buildAttributes = [ "attr1" ];
            };
          };
          nixpkgs.overlays = [ nixOverlay ];
        };
      gitweb =
        { ... }:

        {
          services.lighttpd = {
            enable = true;
            enableModules = [
              "mod_auth"
              "mod_authn_file"
              "mod_setenv"
              "mod_cgi"
              "mod_alias"
            ];

            extraConfig = ''
              auth.backend = "plain"
              auth.backend.plain.userfile = "${pkgs.writeText "userfile" (aliceUsername + ":" + alicePassword)}"

              # this must be set to require auth under this domain.
              auth.require = ( "" => ("method" => "basic", "realm" => "example", "require" => "valid-user") )

              alias.url = ( "" => "${pkgs.git}/libexec/git-core/git-http-backend" )
              setenv.set-environment = ( "GIT_PROJECT_ROOT" => "${repohome}" )
              cgi.assign = ( "" => "" )
              setenv.set-environment += ( "GIT_HTTP_EXPORT_ALL" => "" )
            '';
          };
          networking.firewall.allowedTCPPorts = [ 80 ];

          environment.systemPackages = [
            pkgs.git
            pkgs.git-crypt
          ];

          services.openssh = {
            enable = true;
            hostKeys = [
              {
                type = "ecdsa";
                path = "/etc/ssh/ssh_host_ecdsa_key";
              }
            ];
          };
          users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
          # make ssh key gen deterministic
          systemd.services.sshd.preStart = lib.mkForce ''
            mkdir -m 0755 -p /etc/ssh
            cp "${snakeOilPrivateKey}" /etc/ssh/ssh_host_ecdsa_key
            chmod 600 /etc/ssh/ssh_host_ecdsa_key
            echo "${snakeOilPublicKey}" > /etc/ssh/ssh_host_ecdsa_key.pub
            chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
          '';

        };
    };
    testScript =
      { nodes, ... }:
      ''
        start_all()
        gitweb.wait_for_unit("lighttpd.service")
        gitweb.succeed("${getExe pkgs.git} init --bare ${repohome} -b main")
        gitweb.succeed("${getExe pkgs.git} clone ${repohome}")
        # set the main branch
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git checkout -b main")
        # we can only bush a branch if it contains a commit
        gitweb.succeed("echo \"dummy content\" > ./file")
        gitweb.succeed("echo \"file filter=git-crypt diff=git-crypt\" > ./.gitattributes")
        gitweb.succeed("cd git; ${getExe pkgs.git-crypt} unlock ${./gitCryptKey}")
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git add file")
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git add .gitattributes")
        gitweb.succeed("${getExe pkgs.git} config --global user.email \"<>\"")
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git commit -m \"Initial commit\"")
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git push --set-upstream origin main")
        gitweb.wait_for_open_port(22)
        gitweb.wait_for_open_port(80)
        builder.wait_for_unit("multi-user.target")
        builder.fail("stat /var/lib/flake-auto-upgrade-ssh/fakeFlake")
        builder.systemctl("start flake-auto-upgrade-ssh")
        # flake is added
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-ssh/repo/fakeFlake")
        # attr1 is build
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-ssh/repo/result1")
        # git-crypt file is encrypted
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-ssh/repo/file")
        assert "data" in builder.succeed("${getExe pkgs.file} /var/lib/flake-auto-upgrade-ssh/repo/file")
        # change own for lighttpd
        gitweb.succeed("chown lighttpd:lighttpd -R ${repohome}")
        builder.systemctl("start flake-auto-upgrade-http")
        # flake is changed again
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/fakeFlake")
        assert "2 /var/lib/flake-auto-upgrade-http/repo/fakeFlake" in builder.wait_until_succeeds("wc -l /var/lib/flake-auto-upgrade-http/repo/fakeFlake")
        # attr1 is build
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/result1")
        # attr4 is build
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/result4")
        # git-crypt file is decrypted
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/file")
        assert "ASCII text" in builder.succeed("${getExe pkgs.file} /var/lib/flake-auto-upgrade-http/repo/file")
        # make build of attr1 fail
        builder.succeed("touch /var/lib/flake-auto-upgrade-http/repo/failFile")
        builder.sleep(1)
        builder.systemctl("start flake-auto-upgrade-http")
        # attr3 is build
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/result3")
        # attr4 is build
        builder.wait_until_succeeds("stat /var/lib/flake-auto-upgrade-http/repo/result4")
        # flake is changed again
        assert "3 /var/lib/flake-auto-upgrade-http/repo/fakeFlake" in builder.succeed("wc -l /var/lib/flake-auto-upgrade-http/repo/fakeFlake")
        # Build failure is recorded in the commit message
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git fetch")
        gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git checkout update")
        assert "attr1 failed" in gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git log")
        assert "attr2 failed" in gitweb.succeed("${getExe pkgs.git} --git-dir ./git/.git log")
      '';
  }
)
