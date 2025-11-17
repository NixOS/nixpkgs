# Internal library functions for hardware.facter modules
# Eventually we can think about moving this under lib/
# These are facter-specific helpers for querying nixos-facter reports
lib:
let

  inherit (lib) assertMsg;

  # Query if a facter report contains a CPU with the given vendor name
  hasCpu =
    name:
    {
      hardware ? { },
      ...
    }:
    let
      cpus = hardware.cpu or [ ];
    in
    assert assertMsg (hardware != { }) "no hardware entries found in the report";
    assert assertMsg (cpus != [ ]) "no cpu entries found in the report";
    builtins.any (
      {
        vendor_name ? null,
        ...
      }:
      assert assertMsg (vendor_name != null) "detail.vendor_name not found in cpu entry";
      vendor_name == name
    ) cpus;

  # Extract all driver_modules from a list of hardware entries
  collectDrivers = list: lib.catAttrs "driver_modules" list;

  # Convert number to zero-padded 4-digit hex string (for USB device IDs)
  toZeroPaddedHex =
    n:
    let
      hex = lib.toHexString n;
      len = builtins.stringLength hex;
    in
    if len == 1 then
      "000${hex}"
    else if len == 2 then
      "00${hex}"
    else if len == 3 then
      "0${hex}"
    else
      hex;
in
{
  inherit
    hasCpu
    collectDrivers
    toZeroPaddedHex
    ;

  hasAmdCpu = hasCpu "AuthenticAMD";
  hasIntelCpu = hasCpu "GenuineIntel";

}
