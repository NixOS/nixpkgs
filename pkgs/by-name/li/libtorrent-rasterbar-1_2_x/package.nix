{ lib, stdenv, fetchFromGitHub, pkg-config, automake, autoconf
, zlib, boost, openssl, libtool, python311, libiconv, ncurses, darwin
}:

let
  version = "1.2.11";

  # Make sure we override python, so the correct version is chosen
  # for the bindings, if overridden
  boostPython = boost.override { enablePython = true; python = python311; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "v${version}";
    hash = "sha256-KxyJmG7PdOjGPe18Dd3nzKI5X7B0MovWN8vq7llFFRc=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ automake autoconf libtool pkg-config ];

  buildInputs = [ boostPython openssl zlib python311 libiconv ncurses ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  preConfigure = "./autotool.sh";

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python311.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

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
