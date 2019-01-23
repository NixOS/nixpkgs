{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:
{
  basic = import ./basic.nix { inherit system pkgs; };
  with-postgresql-and-redis = import ./with-postgresql-and-redis.nix { inherit system pkgs; };
  with-mysql-and-memcached = import ./with-mysql-and-memcached.nix { inherit system pkgs; };
}
