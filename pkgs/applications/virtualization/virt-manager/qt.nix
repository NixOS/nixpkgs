{ mkDerivation, lib, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg, qttools, krdc
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
, libselinux, libsepol, utillinux
}:

mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.70.91";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "1z2kq88lljvr24z1kizvg3h7ckf545h4kjhhrjggkr0w4wjjwr43";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg krdc
    libvirt libvncserver pcre pixman qtermwidget spice-gtk spice-protocol
    libselinux libsepol utillinux
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

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
