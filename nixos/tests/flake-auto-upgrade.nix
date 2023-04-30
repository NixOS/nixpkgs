import ./make-test-python.nix ({ lib, pkgs, ... }:

  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

    aliceProjectName = "project";
    alicePassword = "password";
    aliceUsername = "alice";
    repohome = "/var/www/git/";
    nixOverlay = (_: prev: {
      # we have to override nix because we can't build
      # anything without a substituter for bootstrapping
      nix = (pkgs.writeShellScriptBin "nix" ''
        case $@ in
          *\ flake\ *)
            echo "newline" >> ./fakeFlake
            ${pkgs.git}/bin/git add ./fakeFlake
            ${pkgs.git}/bin/git commit -m "Add fake flake"
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
            touch ./result2
            ;;
        esac
      '').overrideAttrs (_: { version = "2.2"; });

    });
  in {
    name = "flake-auto-upgrade";
    meta = with pkgs.lib.maintainers; { maintainers = [ StillerHarpo ]; };

    nodes = {
      builderHttp = { ... }: {
        services.flakeAutoUpgrade = {
          enable = true;
          remote = "http://gitweb";
          credentials = {
            user = aliceUsername;
            passwordFile = pkgs.writeText "password" alicePassword;
          };
          updateBranch = "update";
          buildAttributes = [ "attr1" "attr2" ];
        };
        nixpkgs.overlays = [ nixOverlay ];
      };
      builderSsh = { ... }: {
        services.flakeAutoUpgrade = {
          enable = true;
          remote = "root@gitweb:${repohome}";
          ssh = {
            hostKey = "gitweb " + snakeOilPublicKey;
            key = snakeOilPrivateKey;
          };
          updateBranch = "update";
          buildAttributes = [ "attr1" "attr2" ];
        };
        nixpkgs.overlays = [ nixOverlay ];
      };
      gitweb = { ... }:

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
              auth.backend.plain.userfile = "${
                pkgs.writeText "userfile" (aliceUsername + ":" + alicePassword)
              }"

              # this must be set to require auth under this domain.
              auth.require = ( "" => ("method" => "basic", "realm" => "example", "require" => "valid-user") )

              alias.url = ( "" => "${pkgs.git}/libexec/git-core/git-http-backend" )
              setenv.set-environment = ( "GIT_PROJECT_ROOT" => "${repohome}" )
              cgi.assign = ( "" => "" )
              setenv.set-environment += ( "GIT_HTTP_EXPORT_ALL" => "" )
            '';
          };
          networking.firewall.allowedTCPPorts = [ 80 ];

          environment.systemPackages = [ pkgs.git ];

          services.openssh = {
            enable = true;
            hostKeys = [{
              type = "ecdsa";
              path = "/etc/ssh/ssh_host_ecdsa_key";
            }];
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
    testScript = { nodes, ... }:
      let

      in ''
        start_all()
        gitweb.wait_for_unit("lighttpd.service")
        gitweb.succeed("${pkgs.git}/bin/git init --bare ${repohome}")
        gitweb.succeed("${pkgs.git}/bin/git clone ${repohome}")
        # set the main branch
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git checkout -b main")
        # we can only bush a branch if it contains a commit
        gitweb.succeed("touch ./git/file")
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git add git/file")
        gitweb.succeed("${pkgs.git}/bin/git config --global user.email \"<>\"")
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git commit -m \"Initial commit\"")
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git push --set-upstream origin main")
        gitweb.wait_for_open_port(22)
        gitweb.wait_for_open_port(80)
        builderSsh.wait_for_unit("multi-user.target")
        builderSsh.fail("stat /var/lib/flake-auto-upgrade/fakeFlake")
        builderSsh.systemctl("start flake-auto-upgrade")
        # flake is added
        builderSsh.wait_until_succeeds("stat /var/lib/flake-auto-upgrade/repo/fakeFlake")
        # attr1 is build
        builderSsh.wait_until_succeeds("stat /var/lib/flake-auto-upgrade/repo/result1")
        # change own for lighttpd
        gitweb.succeed("chown lighttpd:lighttpd -R ${repohome}")
        builderHttp.wait_for_unit("multi-user.target")
        builderHttp.systemctl("start flake-auto-upgrade")
        # flake is changed again
        builderHttp.wait_until_succeeds("stat /var/lib/flake-auto-upgrade/repo/fakeFlake")
        assert "2 /var/lib/flake-auto-upgrade/repo/fakeFlake" in builderHttp.wait_until_succeeds("wc -l /var/lib/flake-auto-upgrade/repo/fakeFlake")
        # attr1 is build
        builderHttp.wait_until_succeeds("stat /var/lib/flake-auto-upgrade/repo/result1")
        builderHttp.succeed("touch /var/lib/flake-auto-upgrade/repo/failFile")
        builderHttp.systemctl("start flake-auto-upgrade")
        # attr2 is build
        builderHttp.wait_until_succeeds("stat /var/lib/flake-auto-upgrade/repo/result2")
        # flake is changed again
        assert "3 /var/lib/flake-auto-upgrade/repo/fakeFlake" in builderHttp.succeed("wc -l /var/lib/flake-auto-upgrade/repo/fakeFlake")
        # Build failure is recorded in the commit message
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git fetch")
        gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git checkout update")
        assert "attr1 failed" in gitweb.succeed("${pkgs.git}/bin/git --git-dir ./git/.git log")
      '';
  })
