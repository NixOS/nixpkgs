{
  lib,
  stdenv,
  indi-3rdparty,
  indilib,
  indi-with-drivers,
}:

indi-with-drivers.override {
  pname = "indi-full-nonfree";
  inherit (indilib) version;
  extraDrivers = builtins.filter (attrs: lib.meta.availableOn stdenv.hostPlatform attrs) (
    builtins.attrValues indi-3rdparty
  );
}
