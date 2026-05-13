{
  lib,
  stdenv,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpipeline";
  version = "1.5.8";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/libpipeline-${finalAttrs.version}.tar.gz";
    hash = "sha256-GxIDyhUszWOYPD8hEvf+b6Wv1FMhjt5RU9GzHhG7hAU=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./fix-on-osx.patch ];

  # necessary to build on FreeBSD native pending inclusion of
  # https://git.savannah.gnu.org/cgit/config.git/commit/?id=e4786449e1c26716e3f9ea182caf472e4dbc96e0
  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ];

  meta = {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
  };
})
