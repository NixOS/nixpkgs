{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "haste-server" ] ''
      The upstream haste-server repository was deleted and the project has no
      maintained canonical source. Use another maintained pastebin service.
    '')
  ];
}
