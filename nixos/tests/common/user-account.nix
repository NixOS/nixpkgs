{ lib, ... }:

{ users.extraUsers.alice =
    { isNormalUser = true;
      description = "Alice Foobar";
      password = "foobar";
    };

  users.extraUsers.bob =
    { isNormalUser = true;
      description = "Bob Foobar";
      password = "foobar";
    };
}
