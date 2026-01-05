{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spawn-fcgi";
  version = "1.6.6";

  src = fetchurl {
    url = "https://download.lighttpd.net/spawn-fcgi/releases-1.6.x/spawn-fcgi-${finalAttrs.version}.tar.xz";
    hash = "sha256-yWI0XuzwVT7dm/XPYe5F59EYN/NANwZ/vaFlz0rdzhg=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-implicit-function-declaration";

  meta = with lib; {
    homepage = "https://redmine.lighttpd.net/projects/spawn-fcgi";
    description = "Provides an interface to external programs that support the FastCGI interface";
    mainProgram = "spawn-fcgi";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = with platforms; unix;
  };
})
