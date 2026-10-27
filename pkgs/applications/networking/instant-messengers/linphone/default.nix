{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  lib,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphonePackages";
  extra = self: {
    mkLinphoneDerivation = self.mk-linphone-derivation;

    linphoneSdkVersion = "5.5.13";
    linphoneSdkHash = "sha256-RsSMLO7wZ7azWF7/KcERkd5et73w0kUZpwsqj9QxZgc=";
  };
  f =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages;
}
