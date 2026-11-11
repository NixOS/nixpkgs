{
  lib,
  nodes,
  ...
}:

{
  name = "emacs";
  meta.maintainers = lib.teams.emacs.members;

  defaults =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.tests.emacs = {
        package = lib.mkPackageOption pkgs "Emacs" {
          default = [ "emacs" ];
          example = [ "emacs-nox" ];
        };
        wrappedPackage = lib.mkOption {
          type = lib.types.package;
          default = config.tests.emacs.package.pkgs.withPackages (epkgs: [
            epkgs.project-nix-store
          ]);
          defaultText = lib.literalExpression ''
            package.pkgs.withPackages (epkgs: [ epkgs.project-nix-store ])
          '';
          readOnly = true;
          description = "Emacs wrapped by withPackages.";
        };
      };
    };

  nodes.local =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.tests.emacs;
      mkEpkg = import ../../../pkgs/applications/editors/emacs/build-support/tests/mk-epkg.nix {
        inherit lib;
      };
    in
    {
      environment.systemPackages = [
        # Make sure closure of this machine contains both unwrapped and wrapped Emacs
        # so that we can run them in the test script.
        cfg.wrappedPackage

        # Tests
        (cfg.package.pkgs.callPackage (mkEpkg {
          pname = "nixos";
          src = ./nixos.el;
        }) { })
      ]
      ++ [
        cfg.package.pkgs.orderless
        pkgs.cmatrix
      ];
      users.users.root.packages = [
        cfg.package.pkgs.dash
        pkgs.hello
      ];

      environment.etc.ssh-private-key = {
        source = (import ../ssh-keys.nix pkgs).snakeOilEd25519PrivateKey;
        mode = "0600";
      };
      programs.ssh.extraConfig = ''
        StrictHostKeyChecking=no
        IdentityFile=/etc/${config.environment.etc.ssh-private-key.target}
      '';
      systemd.targets.network-online.wantedBy = [ "multi-user.target" ];
      systemd.services.wait-ssh-to-remote = {
        description = "Wait for SSH to Remote";
        documentation = [
          "https://systemd.io/NETWORK_ONLINE/#modifying-the-meaning-of-network-onlinetarget"
          "man:systemd.special(7)"
        ];
        after = [ "nss-lookup.target" ];
        before = [ "network-online.target" ];
        wantedBy = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = [ config.programs.ssh.package ];
        script = ''
          until ssh -o ConnectTimeout=1 ${nodes.remote.networking.hostName} true
          do
            sleep 1
          done
        '';
      };

      environment.sessionVariables = {
        EMACS_TEST_VERBOSE = 1; # Make ERT output verbose
      };
    };

  nodes.remote = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.sl
    ];
    security.sudo.enable = true;

    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
      (import ../ssh-keys.nix pkgs).snakeOilEd25519PublicKey
    ];
  };

  testScript = ''
    start_all()

    for machine in (local, remote):
      machine.wait_for_unit("default.target")

    for emacs in (
      "${lib.getExe nodes.local.tests.emacs.package}",
      "${lib.getExe nodes.local.tests.emacs.wrappedPackage}",
    ):
      local.succeed(f'{emacs} --batch --load=nixos --funcall=ert-run-tests-batch-and-exit')
  '';
}
