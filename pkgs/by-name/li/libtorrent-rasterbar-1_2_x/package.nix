{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, zlib, boost, openssl, python311, libiconv, ncurses, darwin
, boost-build
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rasterbar";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KxyJmG7PdOjGPe18Dd3nzKI5X7B0MovWN8vq7llFFRc=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    boost-build
    pkg-config
    python311.pkgs.setuptools
  ];

  buildInputs = [ (boost.withPython python311) openssl zlib python311 libiconv ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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

  outputs = [ "out" "dev" "python" ];

  configureFlags = [
    "--enable-python-binding"
    "--with-libiconv=yes"
    "--with-boost=${lib.getDev boost}"
    "--with-boost-libdir=${boost.withPython python311}/lib"
  ];

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin;
    platforms = platforms.unix;
  };
})
