{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg, qttools, krdc
, libvncserver, libvirt, pcre, pixman, qtermwidget, spice-gtk, spice-protocol
, libselinux, libsepol, utillinux
}:

mkDerivation rec {
  pname = "virt-manager-qt";
  version = "0.71.95";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = version;
    sha256 = "1s8753bzsjyixpv1c2l9d1xjcn8i47k45qj7pr50prc64ldf5f47";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
    "-DQTERMWIDGET_INCLUDE_DIRS=${qtermwidget}/include/qtermwidget5"
  ];

  patches = [
    (fetchpatch {
      # Maintainer note: Check whether this patch is still needed when a new version is released
      name = "krdc-variable-name-changes.patch";
      url = "https://github.com/fadenb/qt-virt-manager/commit/4640f5f64534ed7c8a1ecc6851f1c7503988de6d.patch";
      sha256 = "1chl58nra1mj96n8jmnjbsyr6vlwkhn38afhwqsbr0bgyg23781v";
    })
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg krdc
    libvirt libvncserver pcre pixman qtermwidget spice-gtk spice-protocol
    libselinux libsepol utillinux
  ];

  nativeBuildInputs = [ cmake pkgconfig qttools ];

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
