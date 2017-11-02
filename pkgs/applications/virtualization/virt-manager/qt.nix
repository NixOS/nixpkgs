{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg
, lxqt, libvncserver, libvirt, pcre, pixman, spice_gtk, spice_protocol
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.45.75";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "1s59g7kkz8481y8yyf89f549xwbg1978zj9ds61iy94mwz80b38n";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg lxqt.qtermwidget
    libvirt libvncserver pcre pixman spice_gtk spice_protocol
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage    = https://f1ash.github.io/qt-virt-manager;
    description = "Desktop user interface for managing virtual machines (QT)";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license     = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
