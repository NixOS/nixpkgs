{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  file-sink = import ./file-sink.nix { inherit system pkgs; };
  api = import ./api.nix { inherit system pkgs; };
  dnstap = import ./dnstap.nix { inherit system pkgs; };
  nginx-clickhouse = import ./nginx-clickhouse.nix { inherit system pkgs; };
  syslog-quickwit = import ./syslog-quickwit.nix { inherit system pkgs; };
}
