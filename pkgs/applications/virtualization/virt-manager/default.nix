{ stdenv, fetchurl, python2Packages, intltool, file
, wrapGAppsHook, gtkvnc, vte, avahi, dconf
, gobjectIntrospection, libvirt-glib, system-libvirt
, gsettings_desktop_schemas, glib, libosinfo, gnome3, gtk3
, spiceSupport ? true, spice_gtk ? null
}:

with stdenv.lib;

python2Packages.buildPythonApplication rec {
  name = "virt-manager-${version}";
  version = "1.5.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha512 = "b375927776b9132fbd9dacd8223b6c94b89c32d6812394ec7e18df7c66f7e6dec853885e85e2b4b4ffd283e8afe0dd2526bafeac4b55511a4a115ef5798f97da";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool file
    gobjectIntrospection # for setup hook populating GI_TYPELIB_PATH
  ];

  buildInputs =
    [ libvirt-glib vte dconf gtkvnc gnome3.defaultIconTheme avahi
      gsettings_desktop_schemas libosinfo gtk3
    ] ++ optional spiceSupport spice_gtk;

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
    maintainers = with maintainers; [ qknight offline fpletz ];
  };
}
