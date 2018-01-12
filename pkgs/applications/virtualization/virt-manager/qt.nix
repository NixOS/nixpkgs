{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice_gtk, spice_protocol
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.48.79";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "1mzncca9blc742vb77gyfza0sd1rby3qy5yl4x19nkllid92jn6k";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg
    libvirt libvncserver pcre pixman qtermwidget spice_gtk spice_protocol
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
    inherit (qtbase.meta) platforms;
  };
}
