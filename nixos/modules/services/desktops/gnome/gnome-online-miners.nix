# GNOME Online Miners daemon.

{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "gnome" "gnome-online-miners" ] "It was broken for a while now.")
  ];
}
