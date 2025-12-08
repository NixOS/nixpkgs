{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  lib,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphonePackages";
  extra = self: {
    mkLinphoneDerivation = self.mk-linphone-derivation;

    linphoneSdkVersion = "5.4.67";
    linphoneSdkHash = "sha256-QM4EVm7VJeOTt5Dc4DFAJOrGphCRcGniN0Tnfl4zab8=";
  };
  f =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages;
}
