{
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07vnk6bb54k4yc06xnwck7php50l09vvlw1ga8wdz0pia461zpzb";
      type = "gem";
    };
    version = "1.22.1";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07m6lxljabw9kyww5k5lgsxsznsm1v5l14r1la09gqka9b5kv3yr";
      type = "gem";
    };
    version = "1.4.6";
  };
  pgsync = {
    dependencies = [
      "parallel"
      "pg"
      "slop"
      "tty-spinner"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f2lzsa7l88skp18f8w1ch9w8a42pymc48rdaqjrrdgg0126kvj3";
      type = "gem";
    };
    version = "0.7.4";
  };
  slop = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iyrjskgxyn8i1679qwkzns85p909aq77cgx2m4fs5ygzysj4hw4";
      type = "gem";
    };
    version = "4.10.1";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      type = "gem";
    };
    version = "0.9.3";
  };
}
