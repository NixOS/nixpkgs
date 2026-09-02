{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "dspam" ] ''
      The DSPAM project is no longer maintained upstream. Use another maintained
      spam filter instead.
    '')
  ];
}
