{ lib, ... }:

with lib;

{
  imports = [
    (mkRenamedOptionModule [ "boot" "loader" "grub" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "gummiboot" "timeout" ] [ "boot" "loader" "timeout" ])
    (mkRenamedOptionModule [ "boot" "loader" "timeout" ] [ "boot" "loader" "defaults" "timeout" ])
  ];
}
