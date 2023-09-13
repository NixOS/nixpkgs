{ callPackage
}:
rec {
  cpptango = callPackage ./cpptango.nix { inherit tango-idl; };
  tango-idl = callPackage ./tango-idl.nix { };
  database = callPackage ./tango-database.nix { inherit cpptango; };
  access-control = callPackage ./tango-access-control.nix { inherit cpptango; };
  starter = callPackage ./tango-starter.nix { inherit cpptango; };
  admin = callPackage ./tango-admin.nix { inherit cpptango; };
  test = callPackage ./tango-test.nix { inherit cpptango; };
  pogo = callPackage ./pogo.nix { };
  jive = callPackage ./jive.nix { };
  astor = callPackage ./astor.nix { };
}
