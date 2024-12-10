import ./make-test-python.nix {
  name = "postfix";

  nodes.machine = { pkgs, ... }: {
    imports = [ common/user-account.nix ];
    services.postfix = {
      enable = true;
      enableSubmissions = true;
      submissionsOptions = {
        smtpd_tls_security_level = "none";
      };
    };

    environment.systemPackages = let
      checkConfig = pkgs.writeScriptBin "check-config" ''
        #!${pkgs.python3.interpreter}
        import sys

        state = 1
        success = False

        with open("/etc/postfix/master.cf") as masterCf:
          for line in masterCf:
            if state == 1 and line.startswith("submissions"):
              state = 2
            elif state == 2 and line.startswith(" ") and "smtpd_tls_security_level=encrypt" in line:
              success = True
            elif state == 2 and not line.startswith(" "):
              state == 3
        if not success:
          sys.exit(1)
      '';

    in [ checkConfig ];
  };

  testScript = ''
    machine.wait_for_unit("postfix.service")
    machine.succeed("check-config")
  '';
}
