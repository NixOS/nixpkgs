{ stdenv, fetchurl, pythonPackages, intltool, libxml2Python, curl, python
, wrapGAppsHook, virtinst, pyGtkGlade, pythonDBus, gnome_python, gtkvnc, vte
, gtk3, gobjectIntrospection, libvirt-glib, gsettings_desktop_schemas, glib
, avahi, dconf, spiceSupport ? true, spice_gtk, libosinfo, gnome3, system-libvirt
}:

with stdenv.lib;
with pythonPackages;

buildPythonApplication rec {
  name = "virt-manager-${version}";
  version = "1.3.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "0lqd9ix7k4jswqzxarnvxfbq6rvpcm8rrc1if86nw67ms1dh2i36";
  };

  propagatedBuildInputs =
    [ eventlet greenlet gflags netaddr carrot routes
      PasteDeploy m2crypto ipy twisted
      distutils_extra simplejson readline glanceclient cheetah lockfile httplib2
      urlgrabber virtinst pyGtkGlade pythonDBus gnome_python pygobject3
      libvirt libxml2Python ipaddr vte libosinfo gobjectIntrospection gtk3 mox
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
    ${glib}/bin/glib-compile-schemas "$out"/share/glib-2.0/schemas
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
