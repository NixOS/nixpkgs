{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg, qttools
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.57.86";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "ecd1612927a45c97e518ec83ad16f1a2ec158d6d";
    sha256 = "12ajc7z2sd5rdfcklxl7hpcm29zwam0ag93948w49infzrrcnk6k";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg
    libvirt libvncserver pcre pixman qtermwidget spice-gtk spice-protocol
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

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
    inherit (qtbase.meta) platforms;
  };
}
