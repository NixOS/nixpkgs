{ lib, ... }:

{ users.extraUsers = lib.singleton
    { isNormalUser = true;
      name = "alice";
      description = "Alice Foobar";
      password = "foobar";
    };
}
