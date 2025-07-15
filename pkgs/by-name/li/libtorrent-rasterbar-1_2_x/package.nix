{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  zlib,
  boost186,
  openssl,
  python311,
  libiconv,
  ncurses,
  boost-build,
}:

let
  version = "1.2.19";

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
    rev = "v${version}";
    hash = "sha256-HkpaOCBL+0Kc7M9DmnW2dUGC+b60a7n5n3i1SyRfkb4=";
  };

  enableParallelBuilding = true;

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

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
    platforms = platforms.unix;
  };
}
