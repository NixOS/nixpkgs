{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  cctools,
  zlib,
  boost186,
  openssl,
  python311,
  libiconv,
  ncurses,
  boost-build,
}:

let
  # nixpkgs-update: no auto update
  version = "1.2.20";

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost186.override (_: {
    enablePython = true;
    python = python311;
    enableStatic = true;
    enableShared = false;
    enableSingleThreaded = false;
    enableMultiThreaded = true;
    # So that libraries will be named like 'libboost_system.a' instead
    # of 'libboost_system-x64.a'.
    taggedLayout = false;
  });

  opensslStatic = openssl.override (_: {
    static = true;
  });

in
stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    tag = "v${version}";
    hash = "sha256-ImiCxOXIBXJ0L2NdPCVUUd73y6/OekwQZcjChVANc1M=";
  };

  # 1.2.20 quotes the version, which setuptools can't parse
  postPatch = ''
    substituteInPlace bindings/python/setup.cfg \
      --replace-fail 'version = "${version}",' 'version = ${version}'
  '';

  enableParallelBuilding = true;

  env.SETUPTOOLS_USE_DISTUTILS = "stdlib";

  nativeBuildInputs = [
    autoreconfHook
    boost-build
    pkg-config
    python311.pkgs.setuptools
  ];

  buildInputs = [
    boostPython
    opensslStatic
    zlib
    python311
    libiconv
    ncurses
  ];

  preAutoreconf = ''
    mkdir -p build-aux
    cp m4/config.rpath build-aux
  '';

  preConfigure = ''
    configureFlagsArray+=('PYTHON_INSTALL_PARAMS=--prefix=$(DESTDIR)$(prefix) --single-version-externally-managed --record=installed-files.txt')
  ''
  # the python bindings build with b2's darwin toolset, which defaults to g++
  # and to the GNU libtool that autoreconfHook puts on PATH;
  # boostPython is built untagged, the -mt name is MacPorts'
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Jamfile \
      --replace-fail '<name>boost_system-mt' '<name>boost_system'
    echo "using darwin : : ${stdenv.cc.targetPrefix}c++ : <archiver>${lib.getExe' cctools "libtool"} ;" > "$NIX_BUILD_TOP/user-config.jam"
    export BOOST_BUILD_USER_CONFIG="$NIX_BUILD_TOP/user-config.jam"
  '';

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python311.libPrefix}" "$python"
  '';

  outputs = [
    "out"
    "dev"
    "python"
  ];

  configureFlags = [
    "--enable-python-binding"
    "--with-libiconv=yes"
    "--with-boost=${boostPython.dev}"
    "--with-boost-libdir=${boostPython.out}/lib"
  ];

  meta = {
    homepage = "https://libtorrent.org/";
    description = "C++ BitTorrent implementation focusing on efficiency and scalability";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
