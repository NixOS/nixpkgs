{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2017-12-01";
  src = fetchgit {
    sha256 = "0qf7d7268kdxnb723c03m6icxhbgx0vw8gqvck2q1w5b948dy9g8";
    rev = "e895ee55bec8a3320a0e972b32c05d35b47fe226";
    url = "https://gitlab.com/sane-project/backends.git";
  };
})
