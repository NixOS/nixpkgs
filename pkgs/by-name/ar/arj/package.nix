{
  gccStdenv,
  lib,
  fetchurl,
  fetchzip,
  autoreconfHook,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "arj";
  version = "3.10.22";
  debianrev = "28";

  src = fetchurl {
    url = "http://deb.debian.org/debian/pool/main/a/arj/arj_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-WJ5Mm8zIZp57bY1vzWTgH2osIf4QqtVqgzBOzDuWp9s=";
  };

  versionPatch = fetchzip {
    url = "http://deb.debian.org/debian/pool/main/a/arj/arj_${finalAttrs.version}-${finalAttrs.debianrev}.debian.tar.xz";
    hash = "sha256-rmu5RSZ6OHGT093PShzkvC3ktm/U6smta6pmn9D7Jfw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch =
    lib.optionalString gccStdenv.hostPlatform.isDarwin ''
      substituteInPlace environ.c \
          --replace-fail "  #include <sys/statfs.h>" "  #include <sys/mount.h>"
    ''
    + ''
      cp -r ${finalAttrs.versionPatch} ./debian
      chmod +w debian/patches/gnu_build_cross.patch
      chmod +w debian/patches
      mv debian/patches/gnu_build_cross.patch debian/patches/zz_for_last_gnu_build_cross.patch # This patch should be applied at last
      for fname in debian/patches/*.patch
        do
          patch -p1 < "$fname"
        done
    '';

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
    ];
  };

  preAutoreconf = ''
    cd gnu
  '';

  postConfigure = ''
    cd ..
  '';

  meta = {
    description = "Open-source implementation of the world-famous ARJ archiver";
    longDescription = ''
      This version of ARJ has been created with an intent to preserve maximum
      compatibility and retain the feature set of the original ARJ archiver as
      provided by ARJ Software, Inc.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.unix;
  };
})
