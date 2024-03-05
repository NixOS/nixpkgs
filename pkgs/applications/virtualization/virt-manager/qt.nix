{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, pkg-config
, qtbase, qtmultimedia, qtsvg, qttools, krdc
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
, libselinux, libsepol, util-linux
}:

mkDerivation rec {
  pname = "virt-manager-qt";
  version = "0.72.97";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = version;
    sha256 = "0b2bx7ah35glcsiv186sc9cqdrkhg1vs9jz036k9byk61np0cb1i";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  patches = [
    (fetchpatch {
      # drop with next update
      url = "https://github.com/F1ash/qt-virt-manager/commit/0d338b037ef58c376d468c1cd4521a34ea181edd.patch";
      sha256 = "1wjqyc5wsnxfwwjzgqjr9hcqhd867amwhjd712qyvpvz8x7p2s24";
    })
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
