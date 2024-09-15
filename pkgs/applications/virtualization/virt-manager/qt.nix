{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, qtbase, qtmultimedia, qtsvg, qttools, krdc
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
, libselinux, libsepol, util-linux
}:

mkDerivation rec {
  pname = "virt-manager-qt";
  version = "0.72.99";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = version;
    hash   = "sha256-1aXlGlK+YPOe2X51xycWvSu8YC9uCywyL6ItiScFA04=";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg krdc
    libvirt libvncserver pcre pixman qtermwidget spice-gtk spice-protocol
    libselinux libsepol util-linux
  ];

  nativeBuildInputs = [ cmake pkg-config qttools ];

  meta = with lib; {
    homepage    = "https://f1ash.github.io/qt-virt-manager";
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
