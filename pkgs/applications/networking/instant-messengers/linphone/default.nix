{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  lib,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphonePackages";
  extra = self: {
    mkLinphoneDerivation = self.mk-linphone-derivation;

    linphoneSdkVersion = "5.4.43";
    linphoneSdkHash = "sha256-lv2phU2qF51OIejzjgaBUo9NIdDv4bbK+bpY37Gnr8U=";
  };
  f =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages;
}
