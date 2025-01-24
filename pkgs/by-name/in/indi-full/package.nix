{
  lib,
  stdenv,
  indi-3rdparty,
  indi-with-drivers,
  indilib,
}:

let
  licenseFree = p: p.meta.license.free or false;
  isFree =
    p:
    (builtins.all licenseFree ((p.buildInputs or [ ]) ++ (p.propagatedBuildInputs or [ ])))
    && licenseFree p;
  drivers = builtins.filter (
    attrs: isFree attrs && (lib.meta.availableOn stdenv.hostPlatform attrs)
  ) (builtins.attrValues indi-3rdparty);
in
indi-with-drivers.override {
  pname = "indi-full";
  inherit (indilib) version;
  extraDrivers = drivers;
}
