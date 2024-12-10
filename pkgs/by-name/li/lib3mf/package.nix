{ lib, stdenv, fetchFromGitHub, cmake, ninja, automaticcomponenttoolkit
, pkg-config, libzip, gtest, openssl, libuuid, libossp_uuid }:

stdenv.mkDerivation rec {
  pname = "lib3mf";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WMTTYYgpCIM86a6Jw8iah/YVXN9T5youzEieWL/d+Bc=";
  };

  patches = [ ./upgrade-to-cpp-14.patch ];

  nativeBuildInputs = [ cmake ninja pkg-config ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include/lib3mf"
    "-DUSE_INCLUDED_ZLIB=OFF"
    "-DUSE_INCLUDED_LIBZIP=OFF"
    "-DUSE_INCLUDED_GTEST=OFF"
    "-DUSE_INCLUDED_SSL=OFF"
  ];

  buildInputs = [
    libzip gtest openssl
  ] ++ (if stdenv.hostPlatform.isDarwin then [ libossp_uuid ] else [ libuuid ]);

  postPatch = ''
    # This lets us build the tests properly on aarch64-darwin.
    substituteInPlace CMakeLists.txt \
      --replace 'SET(CMAKE_OSX_ARCHITECTURES "x86_64")' ""

    # fix libdir=''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@
    sed -i 's,libdir=''${\(exec_\)\?prefix}/,libdir=,' lib3mf.pc.in

    # replace bundled binaries
    for i in AutomaticComponentToolkit/bin/act.*; do
      ln -sf ${automaticcomponenttoolkit}/bin/act $i
    done
  '';

  meta = with lib; {
    description = "Reference implementation of the 3D Manufacturing Format file standard";
    homepage = "https://3mf.io/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
