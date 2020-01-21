{ system ? builtins.currentSystem,
  config ? {},
  overlays ? [],
  pkgs ? import ../../.. { inherit system config overlays; }
}:
{
  basic = import ./basic.nix { inherit system pkgs; };
  with-postgresql-and-redis = import ./with-postgresql-and-redis.nix { inherit system pkgs; };
  with-mysql-and-memcached = import ./with-mysql-and-memcached.nix { inherit system pkgs; };
}
