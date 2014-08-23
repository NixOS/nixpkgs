{ pkgs, ... }:

{ users.extraUsers = pkgs.lib.singleton
    { isNormalUser = true;
      name = "alice";
      description = "Alice Foobar";
      password = "foobar";
      uid = 1000;
    };
}
