{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (pkgs) lib;

  tests = {
    default = {
      name = "sddm";

      nodes.machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      enableOCR = true;

      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
        machine.send_chars("${user.password}\n")
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.wait_for_window("^IceWM ")
      '';
    };

    autoLogin = {
      name = "sddm-autologin";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ ttuegel ];
      };

      nodes.machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager = {
          sddm.enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.wait_for_window("^IceWM ")
      '';
    };
  };


  /*
  Tests using different shell dot profile files
  to initialize the graphical session
  key = shell name
  value = list of profile files
          these files will be created in user's home directory
          each will be prefixed with a "."
  */
  profileTestConfigs = {
    bash = [ "bash_profile" "bash_login" "profile" ];
    #zsh = [ "zprofile" ];
  };

  profileTestBase = {
      name = "sddm";

      nodes.machine = { ... }: {
        # TODO add method to support setting the user's shell
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      enableOCR = true;

      topTestScript = ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
      '';
      bottomTestScript = { nodes, profile, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        machine.send_chars("${user.password}\n")
        machine.wait_for_file("/tmp/hello_from_${profile}")
        machine.succeed("cat /tmp/hello_from_${profile}")
      '';
  };

  /*
  Make list containing a list of profile tests per shell
  [
    # tests for shell A
    []
    # tests for shell B
    []
    #...
  */
  profileTestSets = lib.mapAttrsToList (shell: profile: makeProfileTests shell profile) profileTestConfigs;
  profileTests = builtins.listToAttrs (lib.flatten profileTestSets);

  /*
  Makes a list of sets for the shell's profile files
  The sets are ready to be passed to builtins.listToAttrs
  */
  makeProfileTests = shell: profiles:
    map (profile: {
      name = makeProfileTestName shell profile;
      value = makeProfileTest shell profile;
    }) profiles;

  makeProfileTestName = shell: profile: "sddm-${shell}-${profile}";

  /*
  Generates a test configuration for `makeTest` function
  Each one ensures that the shell's profile file has the intended effect
   when starting the graphical session
  */
  makeProfileTest = shell: profile: let
      profileContent = pkgs.writeText "${profile}" ''
        echo "Great success!" > /tmp/hello_from_${profile}
      '';
      profileTest = {
        name = makeProfileTestName shell profile;

        # TODO Install shell and set default shell of user
        testScript = {nodes, ...}: let
          user = nodes.machine.config.users.users.alice;
        in
          profileTestBase.topTestScript + ''
          # Write profile file
          machine.copy_from_host("${profileContent}", "${user.home}/.${profile}")
          '' + profileTestBase.bottomTestScript { inherit nodes profile; };
      };
  in
    lib.recursiveUpdate profileTestBase profileTest;

  allTests = tests // profileTests;
in
  lib.mapAttrs (lib.const makeTest) allTests
