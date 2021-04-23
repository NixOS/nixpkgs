{ lib, fetchurl, python3Packages, intltool, file
, wrapGAppsHook, gtk-vnc, vte, avahi, dconf
, gobject-introspection, libvirt-glib, system-libvirt
, gsettings-desktop-schemas, libosinfo, gnome3
, gtksourceview4, docutils
, spiceSupport ? true, spice-gtk ? null
, cpio, e2fsprogs, findutils, gzip
}:

with lib;

python3Packages.buildPythonApplication rec {
  pname = "virt-manager";
  version = "3.2.0";

  src = fetchurl {
    url = "https://releases.pagure.org/virt-manager/${pname}-${version}.tar.gz";
    sha256 = "11kvpzcmyir91qz0dsnk7748jbb4wr8mrc744w117qc91pcy6vrb";
  };

  nativeBuildInputs = [
    intltool file
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    docutils
  ];

  buildInputs = [
    wrapGAppsHook
    libvirt-glib vte dconf gtk-vnc gnome3.adwaita-icon-theme avahi
    gsettings-desktop-schemas libosinfo gtksourceview4
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
  ] ++ optional spiceSupport spice-gtk;

  propagatedBuildInputs = with python3Packages;
    [
      pygobject3 ipaddress libvirt libxml2 requests
    ];

  patchPhase = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python3Packages.python.interpreter} setup.py configure --prefix=$out
  '';

  setupPyGlobalFlags = [ "--no-update-icon-cache" ];

  preFixup = ''
    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    # these are called from virt-install in initrdinject.py
    gappsWrapperArgs+=(--prefix PATH : "${makeBinPath [ cpio e2fsprogs file findutils gzip ]}")
  '';

  # Failed tests
  doCheck = false;

  meta = with lib; {
    homepage = "http://virt-manager.org";
    description = "Desktop user interface for managing virtual machines";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = licenses.gpl2;
    # exclude Darwin since libvirt-glib currently doesn't build there
    platforms = platforms.linux;
    maintainers = with maintainers; [ qknight offline fpletz globin ];
  };
}
