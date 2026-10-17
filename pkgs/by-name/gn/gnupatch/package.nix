{
  lib,
  stdenv,
  fetchurl,
  ed,
  autoreconfHook,
}:

# Note: this package is used for bootstrapping fetchurl, and thus cannot use
# fetchpatch! Any mutable patches (retrieved from GitHub, cgit or any other
# place) that are needed here should be directly included together as regular
# files.

stdenv.mkDerivation (finalAttrs: {
  pname = "patch";
  version = "2.8";

  src = fetchurl {
    url = "mirror://gnu/patch/patch-${finalAttrs.version}.tar.xz";
    hash = "sha256-+Hzuae7CtPy/YKOWsDCtaqNBXxkqpffuhMrV4R9/WuM=";
  };

  patches = [
    # Avoid a null pointer dereference with bad hunks.
    # https://cgit.git.savannah.gnu.org/cgit/patch.git/commit/?id=e6d6a4e021660679d7fc9150f981d4920f722313
    ./CVE-2026-56288.patch
    # Do not loop forever on null ranges.
    # https://cgit.git.savannah.gnu.org/cgit/patch.git/commit/?id=faba04ef4f2b410257f76c1b9dc85e350929c4b9
    ./CVE-2026-56289.patch
  ];

  # This test is filesystem-dependent - observed failing on ZFS.
  # It is also just plain flaky: it has been observed failing about 10%
  # of the time on btrfs and ext4 too.
  postPatch = ''
    sed -E -i -e '/bad-filenames/d' tests/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_strnlen_working=yes"
  ];

  doCheck = stdenv.hostPlatform.libc != "musl";
  nativeCheckInputs = [ ed ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "GNU Patch, a program to apply differences to files";
    mainProgram = "patch";
    longDescription = ''
      GNU Patch takes a patch file containing a difference listing
      produced by the diff program and applies those differences to one or
      more original files, producing patched versions.
    '';
    homepage = "https://savannah.gnu.org/projects/patch";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
    platforms = lib.platforms.all;
  };
})
