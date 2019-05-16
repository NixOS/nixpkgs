{ ... }:

{ users.users.alice =
    { isNormalUser = true;
      description = "Alice Foobar";
      password = "foobar";
    };

  users.users.bob =
    { isNormalUser = true;
      description = "Bob Foobar";
      password = "foobar";
    };
}
