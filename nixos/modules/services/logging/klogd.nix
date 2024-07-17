{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "security"
        "klogd"
        "enable"
      ]
      ''
        Logging of kernel messages is now handled by systemd.
      ''
    )
  ];
}
