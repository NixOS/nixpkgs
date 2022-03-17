{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

with pkgs.lib;

forEach [ 22 23 ] (ver:
  forEach [ "nginx" "caddy" ] (webserver: {
    "basic${toString ver}" = import ./basic.nix {
      inherit system pkgs;
      nextcloudVersion = ver;
      webserver = webserver;
    };
    "with-postgresql-and-redis${toString ver}" = import ./with-postgresql-and-redis.nix {
      inherit system pkgs;
      nextcloudVersion = ver;
      webserver = webserver;
    };
    "with-mysql-and-memcached${toString ver}" = import ./with-mysql-and-memcached.nix {
      inherit system pkgs;
      nextcloudVersion = ver;
      webserver = webserver;
    };
  })
)
