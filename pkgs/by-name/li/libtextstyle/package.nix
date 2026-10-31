{
  fetchurl,
  lib,
  stdenv,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtextstyle";
  version = "1.0";

  outputs = [
    "out"
    "doc"
    "info"
  ];

  src = fetchurl {
    url = "mirror://gnu/gettext/gettext-${finalAttrs.version}.tar.gz";
    hash = "sha256-hdmbecmBpASHTALgNCF2z3XHaY4rUf5BAxz2Um2XTxo=";
  };

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
  ];

  strictDeps = true;

  __structuredAttrs = true;

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # On cross building, gettext supposes that the wchar.h from libc
    # does not fulfill gettext needs, so it tries to work with its
    # own wchar.h file, which does not cope well with the system's
    # wchar.h and stddef.h (gcc-4.3 - glibc-2.9)
    "gl_cv_func_wcwidth_works=yes"
  ];

  postPatch =
    lib.optionalString stdenv.hostPlatform.isMinGW ''
      sed -i "s/@GNULIB_CLOSE@/1/" */*/unistd.in.h
    ''
    + ''
      cd libtextstyle
    '';

  meta = {
    description = "Text styling library";

    longDescription = ''
      This library provides an easy way to add styling to programs that
      produce output to a console or terminal emulator window.

      libtextstyle is for you if your application produces text that is more
      readable when it is accompanied with styling information, such as color,
      font attributes (weight, posture), or underlining.
    '';

    homepage = "https://www.gnu.org/software/gettext/";

    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
