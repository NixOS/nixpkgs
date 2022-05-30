{ lib }:

let
  defaultSourceType = tname: {
    shortName = tname;
  };
in lib.mapAttrs (tname: tset: defaultSourceType tname // tset) {

  binaryNativeCode = {};

  binaryBytecode = {};

  binaryFirmware = {};
}
