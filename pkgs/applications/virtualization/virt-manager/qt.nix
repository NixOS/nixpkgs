{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg
, lxqt, libvncserver, libvirt, pixman, spice_gtk, spice_protocol
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.43.72";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "0m8aqs58wnk404z2hav5j4yjsy8f0vfsm771pm0gprsfbx4sm3qg";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg lxqt.qtermwidget
    libvirt libvncserver pixman spice_gtk spice_protocol
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with lib; {
    homepage = http://f1ash.github.io/qt-virt-manager;
    description = "Desktop user interface for managing virtual machines (QT)";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
