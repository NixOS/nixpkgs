{
  lib,
  stdenv,
  fetchurl,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmodplug";
  version = "0.8.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/modplug-xmms/libmodplug/${finalAttrs.version}/libmodplug-${finalAttrs.version}.tar.gz";
    sha256 = "1pnri98a603xk47smnxr551svbmgbzcw018mq1k6srbrq6kaaz25";
  };

  # Unfortunately, upstream appears inactive and the patches from the fork don’t apply cleanly.
  # Modify `src/fastmix.cpp` to remove usage of the register storage class, which is
  # not allowed in C++17 and is an error in clang 16.
  prePatch = "substituteInPlace src/fastmix.cpp --replace 'register ' ''";

  outputs = [
    "out"
    "dev"
  ];

  preConfigure = ''
    substituteInPlace configure \
       --replace ' -mmacosx-version-min=10.5' "" \
       --replace /usr/bin/file ${file}/bin/file
  '';

  meta = {
    description = "MOD playing library";
    homepage = "https://modplug-xmms.sourceforge.net/";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ raskin ];
  };
})
