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
    linphoneSdkHash = "sha256-YG+GF6En1r8AYoIj7E5hqPcmXidMmO0ZKVx/YC5w55I=";
  };
  f =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages;
}
