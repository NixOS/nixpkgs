{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libndp";
  version = "1.9";

  src = fetchurl {
    url = "http://libndp.org/files/libndp-${version}.tar.gz";
    hash = "sha256-qKshTgHcOpthUnaQU5VjfzkSmMhNd2UfDL8LEILdLdQ=";
  };

  patches = [
    (fetchurl {
      name = "musl.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/libndp/0001-Patch-libndp.c.patch?id=00406a9c697d88f531962cb63e5343488a959b93";
      hash = "sha256-1ZcXgZv3mYtt5NaK4rUMnScWVajlWQ+anzBDS5IfgJI=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/jpirko/libndp.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    mainProgram = "ndptool";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.lgpl21;
  };

}
