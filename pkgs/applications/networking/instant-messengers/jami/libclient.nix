{ version
, src
, jami-meta
, stdenv
, lib
, pkg-config
, cmake
, qtbase
, jami-daemon
}:

stdenv.mkDerivation {
  pname = "jami-libclient";
  inherit version src;

  sourceRoot = "source/lrc";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    jami-daemon
  ];

  patches = [
    # Fix path to include dir when using split outputs
    ./libclient-include-path.patch
  ];

  propagatedBuildInputs = [
    qtbase
  ];
  outputs = [ "out" "dev" ];

  cmakeFlags = [
    "-DRING_BUILD_DIR=${jami-daemon}/include"
    "-DRING_XML_INTERFACES_DIR=${jami-daemon}/share/dbus-1/interfaces"
  ];

  dontWrapQtApps = true;

  meta = jami-meta // {
    description = "The client library" + jami-meta.description;
    license = lib.licenses.lgpl21Plus;
  };
}
