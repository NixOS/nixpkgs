{ stdenv, fetchurl, python2Packages, intltool, curl
, wrapGAppsHook, virtinst, gtkvnc, vte
, gtk3, gobjectIntrospection, libvirt-glib, gsettings_desktop_schemas, glib
, avahi, dconf, spiceSupport ? true, spice_gtk, libosinfo, gnome3, system-libvirt
}:

with stdenv.lib;
with python2Packages;

buildPythonApplication rec {
  name = "virt-manager-${version}";
  version = "1.4.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "1jnawqjmcqd2db78ngx05x7cxxn3iy1sb4qfgbwcn045qh6a8cdz";
  };

  propagatedBuildInputs =
    [ eventlet greenlet gflags netaddr carrot routes
      PasteDeploy m2crypto ipy twisted
      distutils_extra simplejson glanceclient cheetah lockfile httplib2
      urlgrabber virtinst pyGtkGlade dbus-python /*gnome_python FIXME*/ pygobject3
      libvirt libxml2 ipaddr vte libosinfo gobjectIntrospection gtk3 mox
      gtkvnc libvirt-glib glib gsettings_desktop_schemas gnome3.defaultIconTheme
      wrapGAppsHook
    ] ++ optional spiceSupport spice_gtk;

  buildInputs = [ dconf avahi intltool ];

  patchPhase = ''
    sed -i 's|/usr/share/libvirt/cpu_map.xml|${system-libvirt}/share/libvirt/cpu_map.xml|g' virtinst/capabilities.py
    sed -i "/'install_egg_info'/d" setup.py
  '';

  postConfigure = ''
    ${python.interpreter} setup.py configure --prefix=$out
  '';

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out"/share/glib-2.0/schemas
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
    maintainers = with maintainers; [qknight offline];
  };
}
