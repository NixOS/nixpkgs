{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libmodule";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "FedeDP";
    repo = "libmodule";
    rev = version;
    sha256 = "sha256-wkRiDWO9wUyxkAeqvm99u22Jq4xnQJx6zS7Sb+R8iMg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # https://github.com/FedeDP/libmodule/issues/7
  postPatch = ''
    substituteInPlace Extra/libmodule.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "C simple and elegant implementation of an actor library";
    homepage = "https://github.com/FedeDP/libmodule";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
