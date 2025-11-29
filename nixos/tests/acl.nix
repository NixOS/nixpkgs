{
  name = "acl";
  testScript = ''
    # systemd-cat shows logs while running
    machine.succeed("systemd-cat -t acl-test -p notice acl-test")
  '';
  nodes.machine =
    { pkgs, lib, ... }:
    let
      aclTest = pkgs.writeShellScriptBin "acl-test" ''
        # Copy all build-time variables to replicate the environment
        # TODO: The inputDerivation's single file happens to be sourcable for this package,
        # but there's no guarantee of that being the case
        source ${acl'.inputDerivation}
        # Set state to match some potentially-impure environment
        # (this is what Nix does before executing the builder too)
        ${lib.getExe' pkgs.coreutils "mkdir"} -p "$NIX_BUILD_TOP"
        cd "$PWD"
        # Run the derivation build
        exec "$_derivation_original_builder" $_derivation_original_args
      '';

      acl' = pkgs.acl.overrideAttrs (old: {
        postPatch = old.postPatch or "" + ''
          # The runwrapper uses LD_PRELOAD to override available user/groups,
          # but it doesn't work well on NixOS for some reason
          substituteInPlace Makefile.in --replace-fail \
            'TEST_LOG_COMPILER = $(srcdir)/test/runwrapper' \
            'TEST_LOG_COMPILER = $(srcdir)/test/run'
        '';
        nativeCheckInputs = old.nativeCheckInputs or [ ] ++ [
          pkgs.perl
          # By default `ls` would come from bootstrap tools,
          # which doesn't support showing ACLs, which the tests rely on
          pkgs.coreutils
        ];
        doCheck = true;
        # /nix/store is not writable, and we don't care about installation for testing
        dontInstall = true;
        dontFixup = true;
      });
    in
    {
      environment.systemPackages = [ aclTest ];

      # Don't need network, save some power :)
      networking.useDHCP = false;
      networking.interfaces = lib.mkForce { };

      # Mirror https://cgit.git.savannah.gnu.org/cgit/acl.git/tree/test/test.passwd?id=9053e722421454b115e699743a9b0a66808ab756
      users.users = {
        bin = {
          isSystemUser = true;
          group = "bin";
          uid = 1;
        };
        daemon = {
          isSystemUser = true;
          group = "daemon";
          extraGroups = [ "bin" ];
          uid = 2;
        };
        "domain\\user" = {
          isSystemUser = true;
          group = "bin";
          uid = 3;
        };
        "domain\\12345" = {
          isSystemUser = true;
          group = "bin";
          uid = 4;
        };
      };

      # Mirror https://cgit.git.savannah.gnu.org/cgit/acl.git/tree/test/test.group?id=9053e722421454b115e699743a9b0a66808ab756
      users.groups.bin.gid = 1;
      users.groups.daemon.gid = 2;
      users.groups.loooooooooooooooooooooooonggroup.gid = 1000;

      # Release uid 4 and gid's 1 and 2, which by default are allocated to these uses
      ids = {
        uids.messagebus = lib.mkForce 6;
        gids.wheel = lib.mkForce 10;
        gids.kmem = lib.mkForce 11;
      };

      # Crudely ignore all assertions, because one of them would prevents non-standard user-names
      # Unfortunately there's no way to silence individual assertions without https://github.com/NixOS/nixpkgs/pull/97023
      assertions = lib.mkForce [ ];
    };

}
