{
  fetchurl,
  lib,
  stdenv,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cmocka";
  version = "1.1.8";

  src = fetchurl {
    url = "https://cmocka.org/files/${lib.versions.majorMinor version}/cmocka-${version}.tar.xz";
    hash = "sha256-WENbVYdm1/THKboWO9867Di+07x2batoTjUm7Qqnx4A=";
  };

  patches = [
    ./uintptr_t.patch
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    lib.optional doCheck "-DUNIT_TESTING=ON"
    ++ lib.optional stdenv.hostPlatform.isStatic "-DBUILD_SHARED_LIBS=OFF";

  doCheck = true;

  meta = with lib; {
    description = "Lightweight library to simplify and generalize unit tests for C";
    longDescription = ''
      There are a variety of C unit testing frameworks available however
      many of them are fairly complex and require the latest compiler
      technology.  Some development requires the use of old compilers which
      makes it difficult to use some unit testing frameworks. In addition
      many unit testing frameworks assume the code being tested is an
      application or module that is targeted to the same platform that will
      ultimately execute the test.  Because of this assumption many
      frameworks require the inclusion of standard C library headers in the
      code module being tested which may collide with the custom or
      incomplete implementation of the C library utilized by the code under
      test.

      Cmocka only requires a test application is linked with the standard C
      library which minimizes conflicts with standard C library headers.
      Also, CMocka tries to avoid the use of some of the newer features of
      C compilers.

      This results in CMocka being a relatively small library that can be
      used to test a variety of exotic code. If a developer wishes to
      simply test an application with the latest compiler then other unit
      testing frameworks may be preferable.

      This is the successor of Google's Cmockery.
    '';
    homepage = "https://cmocka.org/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [
      kragniz
      rasendubi
    ];
  };
}
