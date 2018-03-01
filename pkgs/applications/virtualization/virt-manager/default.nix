{ stdenv, fetchurl, python2Packages, intltool, file
, wrapGAppsHook, gtkvnc, vte, avahi, dconf
, gobjectIntrospection, libvirt-glib, system-libvirt
, gsettings-desktop-schemas, glib, libosinfo, gnome3, gtk3
, spiceSupport ? true, spice-gtk ? null
}:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  name = "virt-manager-${version}";
  version = "1.5.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "d43a7b99d40acdcb8e9455e7874beee132cfcfce9eed0d6252e8f254a82cadc6";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool file
    gobjectIntrospection # for setup hook populating GI_TYPELIB_PATH
  ];

  buildInputs =
    [ libvirt-glib vte dconf gtkvnc gnome3.defaultIconTheme avahi
      gsettings-desktop-schemas libosinfo gtk3
    ] ++ optional spiceSupport spice-gtk;

  propagatedBuildInputs = with python2Packages;
    [
      pygobject3 ipaddr libvirt libxml2 requests
    ];

  patchPhase = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python2Packages.python.interpreter} setup.py configure --prefix=$out
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
  '';

  # Failed tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://virt-manager.org;
    description = "Desktop user interface for managing virtual machines";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = licenses.gpl2;
    # exclude Darwin since libvirt-glib currently doesn't build there
    platforms = platforms.linux;
    maintainers = with maintainers; [ qknight offline fpletz ];
  };
}
