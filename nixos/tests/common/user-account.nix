{ pkgs, ... }:

{ users.extraUsers = pkgs.lib.singleton
    { name = "alice";
      description = "Alice Foobar";
      home = "/home/alice";
      createHome = true;
      useDefaultShell = true;
      password = "foobar";
      uid = 1000;
    };
}
