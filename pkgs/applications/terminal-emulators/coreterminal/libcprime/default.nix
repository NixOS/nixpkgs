{ stdenv
, lib
, fetchzip
, libnotify
, cmake
, ninja
, qt5
}:

stdenv.mkDerivation rec {
  pname = "libcprime";
  version = "4.2.2";

  src = fetchzip {
    url = "https://gitlab.com/cubocore/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "sha256-RywvFATA/+fDP/TR5QRWaJlDgy3EID//iVmrJcj3GXI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qt5.full
    libnotify
  ];

  meta = with lib; {
    description = "A library for bookmarking, saving recent activites, managing settings of C-Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/libcprime";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
