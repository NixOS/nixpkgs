{ lib }:

let
  defaultSourceType = tname: {
    shortName = tname;
    isSource = false;
  };
in lib.mapAttrs (tname: tset: defaultSourceType tname // tset) {

  fromSource = {
    isSource = true;
  };

  binaryNativeCode = {};

  binaryBytecode = {};

  binaryFirmware = {};
}
