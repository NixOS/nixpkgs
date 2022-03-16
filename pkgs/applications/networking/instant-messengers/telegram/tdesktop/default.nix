{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  pname = "telegram-desktop";
  version = "3.6.0";
  sha256 = "0zcjm08nfdlxrsv0fi6dqg3lk52bcvsxnsf6jm5fv6gf5v9ia3hq";
})
