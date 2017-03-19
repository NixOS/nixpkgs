{ stdenv, fetchFromGitHub, cmake, pkgconfig
, qtbase, qtmultimedia, qtsvg, makeQtWrapper
, lxqt, libvncserver, libvirt, pixman, spice_gtk, spice_protocol
}:

stdenv.mkDerivation rec {
  name = "virt-manager-qt-${version}";
  version = "0.42.67";

  src = fetchFromGitHub {
    owner  = "F1ash";
    repo   = "qt-virt-manager";
    rev    = "${version}";
    sha256 = "0hskaffc84wf8h9qck5xg840jw8x2krfy6cw4hqnq946z9lbyanr";
  };

  cmakeFlags = [
    "-DBUILD_QT_VERSION=5"
  ];

  buildInputs = [
    qtbase qtmultimedia qtsvg lxqt.qtermwidget
    libvirt libvncserver pixman spice_gtk spice_protocol
  ];

  nativeBuildInputs = [ cmake pkgconfig makeQtWrapper ];

  postFixup = ''
    for f in $out/bin/* ; do
      wrapQtProgram $f
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
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
