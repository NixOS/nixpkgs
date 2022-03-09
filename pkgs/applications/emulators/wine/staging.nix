{ lib, callPackage, wineUnstable }:

with callPackage ./util.nix {};

let patch = (callPackage ./sources.nix {}).staging;
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert lib.getVersion wineUnstable == patch.version;

(lib.overrideDerivation wineUnstable (self: {
  buildInputs = build-inputs [ "perl" "util-linux" "autoconf" "gitMinimal" ] self.buildInputs;

  name = "${self.name}-staging";

  prePatch = self.prePatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches .
    chmod +w patches
    cd patches
    patchShebangs gitapply.sh
    ./patchinstall.sh DESTDIR="$PWD/.." --all ${lib.concatMapStringsSep " " (ps: "-W ${ps}") patch.disabledPatchsets}
    cd ..
  '';
})) // {
  meta = wineUnstable.meta // {
    description = wineUnstable.meta.description + " (with staging patches)";
  };
}
