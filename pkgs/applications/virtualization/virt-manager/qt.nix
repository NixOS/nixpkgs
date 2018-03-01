{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg, qttools
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.52.80";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "131rs6c90vdf1j40qj7k6s939y8la9ma0q3labxb7ac3r8hvhn6a";
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
