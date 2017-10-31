{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // {
  version = "2.3.8";
  sha256s = {
    "x86_64-linux" = "02n5s561cz3mprg682mrbmh3qai42dh64jgi05rqy9s6wgbn66ly";
    "i686-linux"   = "118qrnxc7gvm30rsz0xfx6dlxmrr0dk5ajrvszhy06ww7xvqhzji";
  };
})
