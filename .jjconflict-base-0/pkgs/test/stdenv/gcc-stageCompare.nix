# This test *must* be run prior to releasing any build of either stdenv or the
# gcc that it exports!  This check should also be part of CI for any PR that
# causes a rebuild of `stdenv.cc`.
#
# When we used gcc's internal bootstrap it did this check as part of (and
# serially with) the gcc derivation.  Now that we bootstrap externally this
# check can be done in parallel with any/all of stdenv's referrers.  But we
# must remember to do the check.
#

{ stdenv
, pkgs
, lib
}:

assert stdenv.cc.isGNU;
with pkgs;
# rebuild gcc using the "final" stdenv
let gcc-stageCompare = (gcc-unwrapped.override {
      reproducibleBuild = true;
      profiledCompiler = false;
      stdenv = overrideCC stdenv (wrapCCWith {
        cc = stdenv.cc;
      });
    }).overrideAttrs(_: {
      NIX_OUTPATH_USED_AS_RANDOM_SEED = stdenv.cc.cc.out;
    });
in (runCommand "gcc-stageCompare" {} ''
  diff -sr ${pkgs.gcc-unwrapped.checksum}/checksums ${gcc-stageCompare.checksum}/checksums && touch $out
'').overrideAttrs (a: {
  meta = (a.meta or { }) // { platforms = lib.platforms.linux; };
})
