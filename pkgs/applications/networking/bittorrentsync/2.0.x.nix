{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // {
  version = "2.3.7";
  sha256s = {
    "x86_64-linux" = "1hnw6bv60xrnc733gm1ilywc0y93k2g6bmwgnww9qk7ivbvi6pd1";
    "i686-linux"   = "0hj8nbq6mava15m1hxaqq371fqk0whdx5iqsbnppyci0jjnr4qv1";
  };
})
