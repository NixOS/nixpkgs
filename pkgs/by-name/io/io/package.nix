{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, zlib, sqlite, gmp, libffi, cairo,
  ncurses, freetype, libGLU, libGL, libpng, libtiff, libjpeg, readline, libsndfile,
  libxml2, libglut, libsamplerate, pcre, libevent, libedit, yajl,
  python3, openssl, glfw, pkg-config, libpthreadstubs, libXdmcp, libmemcached
}:

stdenv.mkDerivation {
  pname = "io";
  version = "2017.09.06";
  src = fetchFromGitHub {
    owner = "stevedekorte";
    repo = "io";
    rev = "b8a18fc199758ed09cd2f199a9bc821f6821072a";
    sha256 = "07rg1zrz6i6ghp11cm14w7bbaaa1s8sb0y5i7gr2sds0ijlpq223";
  };

  patches = [
    (fetchpatch {
      name = "check-for-sysctl-h.patch";
      url = "https://github.com/IoLanguage/io/pull/446/commits/9f3e4d87b6d4c1bf583134d55d1cf92d3464c49f.patch";
      sha256 = "9f06073ac17f26c2ef6298143bdd1babe7783c228f9667622aa6c91bb7ec7fa0";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib sqlite gmp libffi cairo ncurses freetype
    libGLU libGL libpng libtiff libjpeg readline libsndfile libxml2
    libglut libsamplerate pcre libevent libedit yajl
    glfw openssl libpthreadstubs libXdmcp
    libmemcached python3
  ];

  preConfigure = ''
    # The Addon generation (AsyncRequest and a others checked) seems to have
    # trouble with building on Virtual machines. Disabling them until it
    # can be fully investigated.
    sed -ie \
          "s/add_subdirectory(addons)/#add_subdirectory(addons)/g" \
          CMakeLists.txt
    # Bind Libs STATIC to avoid a segfault when relinking
    sed -i 's/basekit SHARED/basekit STATIC/' libs/basekit/CMakeLists.txt
    sed -i 's/garbagecollector SHARED/garbagecollector STATIC/' libs/garbagecollector/CMakeLists.txt
    sed -i 's/coroutine SHARED/coroutine STATIC/' libs/coroutine/CMakeLists.txt
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/io
    $out/bin/io_static
  '';

  # for gcc5; c11 inline semantics breaks the build
  env.NIX_CFLAGS_COMPILE = "-fgnu89-inline";

  meta = with lib; {
    description = "Io programming language";
    homepage = "https://iolanguage.org/";
    license = licenses.bsd3;

    maintainers = with maintainers; [
      raskin
      maggesi
    ];
    platforms = [ "x86_64-linux" ];
  };
}
