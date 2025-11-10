{
  lib,
  callPackage,
  boost-build,
  fetchurl,
  ...
}@args:

lib.fix (
  self:
  let
    boost = import ../boost/package.nix;
  in
  callPackage boost (
    args
    // {
      version = "1.80.0";
      src = fetchurl {
        urls = [
          "mirror://sourceforge/boost/boost_${builtins.replaceStrings [ "." ] [ "_" ] self.version}.tar.bz2"
          "https://boostorg.jfrog.io/artifactory/main/release/${self.version}/source/boost_${
            builtins.replaceStrings [ "." ] [ "_" ] self.version
          }.tar.bz2"
        ];
        hash = "sha256-HhlWXYLkO8WSCaFo9ayJnTukcdVcdhDGd9TM8snFAMA=";
      };
      boost-build = boost-build.override {
        # useBoost allows us passing in src and version from
        # the derivation we are building to get a matching b2 version.
        useBoost = self;
      };
    }
  )
)
