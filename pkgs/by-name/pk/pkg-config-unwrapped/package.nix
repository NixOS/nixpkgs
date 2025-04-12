{
  lib,
  stdenv,
  fetchurl,
  libiconv,
  vanilla ? false,
}:

stdenv.mkDerivation rec {
  pname = "pkg-config";
  version = "0.29.2";

  src = fetchurl {
    url = "https://pkg-config.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "14fmwzki1rlz8bs2p810lk6jqdxsk966d8drgsjmi54cd00rrikg";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];
  strictDeps = true;

  # Process Requires.private properly, see
  # http://bugs.freedesktop.org/show_bug.cgi?id=4738, migrated to
  # https://gitlab.freedesktop.org/pkg-config/pkg-config/issues/28
  patches =
    lib.optional (!vanilla) ./requires-private.patch
    ++ lib.optional stdenv.hostPlatform.isCygwin ./2.36.3-not-win32.patch;

  # These three tests fail due to a (desired) behavior change from our ./requires-private.patch
  postPatch =
    # this could be accomplished by updateAutotoolsGnuConfigScriptsHook, but that causes infinite recursion
    # necessary for FreeBSD code path in configure
    ''
      substituteInPlace ./config.guess ./glib/config.guess --replace-fail /usr/bin/uname uname
    ''
    + lib.optionalString (!vanilla) ''
      rm -f check/check-requires-private check/check-gtk check/missing
    '';

  buildInputs = [ libiconv ];

  configureFlags =
    [ "--with-internal-glib" ]
    ++ lib.optionals (stdenv.hostPlatform.isSunOS) [
      "--with-libiconv=gnu"
      "--with-system-library-path"
      "--with-system-include-path"
      "CFLAGS=-DENABLE_NLS"
    ]
    # Can't run these tests while cross-compiling
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "glib_cv_stack_grows=no"
      "glib_cv_uscore=no"
      "ac_cv_func_posix_getpwuid_r=yes"
      "ac_cv_func_posix_getgrgid_r=yes"
    ];

  env.NIX_CFLAGS_COMPILE = toString (
    # Silence "incompatible integer to pointer conversion passing 'gsize'" when building with Clang.
    lib.optionals stdenv.cc.isClang [ "-Wno-int-conversion" ]
    # Silence fprintf format errors when building for Windows.
    ++ lib.optionals stdenv.hostPlatform.isWindows [ "-Wno-error=format" ]
  );

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''rm -f "$out"/bin/*-pkg-config''; # clean the duplicate file

  meta = with lib; {
    description = "Tool that allows packages to find out information about other packages";
    homepage = "http://pkg-config.freedesktop.org/wiki/";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    mainProgram = "pkg-config";
  };
}
