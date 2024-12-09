{ lib, stdenv, callPackage, autoconf, hexdump, perl, python3, wineUnstable, gitMinimal }:

with callPackage ./util.nix {};

let patch = (callPackage ./sources.nix {}).staging;
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert lib.versions.majorMinor wineUnstable.version == lib.versions.majorMinor patch.version;

(wineUnstable.override { wineRelease = "staging"; }).overrideAttrs (self: {
  buildInputs = build-inputs ([ "perl" "autoconf" "gitMinimal" ] ++ lib.optional stdenv.hostPlatform.isLinux "util-linux") self.buildInputs;
  nativeBuildInputs = [ autoconf hexdump perl python3 gitMinimal ] ++ self.nativeBuildInputs;

  prePatch = self.prePatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches ${patch}/staging .
    chmod +w patches
    patchShebangs ./patches/gitapply.sh
    python3 ./staging/patchinstall.py DESTDIR="$PWD" --all ${lib.concatMapStringsSep " " (ps: "-W ${ps}") patch.disabledPatchsets}
  '';
}) // {
  meta = wineUnstable.meta // {
    description = wineUnstable.meta.description + " (with staging patches)";
  };
}
