{ lib }:

lib.mapAttrs (tname: tset: let
  defaultSourceType = {
    shortName = tname;
    isSource = false;
  };

  mkSourceType = sourceTypeDeclaration: let
    applyDefaults = sourceType: defaultSourceType // sourceType;
  in lib.pipe sourceTypeDeclaration [
    applyDefaults
  ];
in mkSourceType tset) {

  fromSource = {
    isSource = true;
  };

  binaryNativeCode = {};

  binaryBytecode = {};

  binaryFirmware = {};
}
