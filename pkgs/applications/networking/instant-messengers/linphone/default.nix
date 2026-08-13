{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  lib,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphonePackages";
  extra = self: {
    mkLinphoneDerivation = self.mk-linphone-derivation;

    linphoneSdkVersion = "5.4.85";
    linphoneSdkHash = "sha256-mdJDCuCaZlcQ92P6oMgH/8iWgm8hGz8gTVUilC+yaSU=";
  };
  f =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages;
}
