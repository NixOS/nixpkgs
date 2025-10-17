{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  python3,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "keystone";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "keystone-engine";
    repo = "keystone";
    rev = version;
    sha256 = "020d1l1aqb82g36l8lyfn2j8c660mm6sh1nl4haiykwgdl9xnxfa";
  };

  patches = [
    # Patches from https://github.com/keystone-engine/keystone/pull/593
    ./gcc15.patch
    ./cmake-3.10.patch
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # TODO: could be replaced by setting CMAKE_INSTALL_NAME_DIR?
    fixDarwinDylibNames
  ];

  meta = with lib; {
    description = "Lightweight multi-platform, multi-architecture assembler framework";
    homepage = "https://www.keystone-engine.org";
    license = licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "kstool";
    platforms = platforms.unix;
  };
}
