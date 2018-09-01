let
  ensurePass = name: config:
    builtins.seq
      (builtins.unsafeDiscardOutputDependency
        (import ../lib/eval-config.nix {
          modules = [
            config
            ({
              fileSystems."/".device = "/dev/bogus";
              boot.loader.grub.device = "/dev/bogus";
            })
          ];
        }).config.system.build.toplevel.drvPath
      ) "ok" ;


    ensureFail = name: config:
      if (builtins.tryEval (ensurePass name config)).success == false
      then "ok"
      else throw "unexpected success in ${name}";
in {
  user-with-password = ensurePass "user-with-password" {
    # services.openssh.enable = true;
    users.mutableUsers = false;
    users.users.foo = {
      password = "foob";
      extraGroups = [ "wheel" ];
    };
    users.users.root.hashedPassword = null;
  };

  root-only-no-password = ensureFail "root-only-no-password" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = null;
  };

  root-only-with-bang-password = ensureFail "root-only-with-bang-password" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "!";
  };

  root-only-with-real-password = ensurePass "root-only-with-real-password" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "w00t";
  };

  root-only-with-real-password-ssh-no-login = ensureFail "root-only-with-real-password-ssh-no-login" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "w00t";
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "no";
  };

  root-only-with-real-password-ssh-without-pass-login = ensureFail "root-only-with-real-password-ssh-without-pass-login" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "w00t";
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "without-password";
  };

  root-only-with-real-password-ssh-prohibit-password-login = ensureFail "root-only-with-real-password-ssh-prohibit-password-login" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "w00t";
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "prohibit-password";
  };

  root-only-with-real-password-ssh-no-login-ssh-disabled = ensurePass "root-only-with-real-password-ssh-no-login-ssh-disabled" {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "w00t";
    services.openssh.enable = false;
    services.openssh.permitRootLogin = "no";
  };

}
