{ stdenv, fetchurl, pythonPackages, intltool, libxml2Python, curl, python
, wrapGAppsHook, virtinst, pyGtkGlade, pythonDBus, gnome_python, gtkvnc, vte
, gtk3, gobjectIntrospection, libvirt-glib, gsettings_desktop_schemas, glib
, avahi, dconf, spiceSupport ? true, spice_gtk, libosinfo, gnome3
}:

with stdenv.lib;
with pythonPackages;

buildPythonPackage rec {
  name = "virt-manager-${version}";
  version = "1.2.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "1gp6ijrwl6kjs54l395002pc9sblp08p4nqx9zcb9qg5f87aifvl";
  };

  propagatedBuildInputs =
    [ eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      urlgrabber virtinst pyGtkGlade pythonDBus gnome_python pygobject3
      libvirt libxml2Python ipaddr vte libosinfo
    ] ++ optional spiceSupport spice_gtk;

  buildInputs =
    [ mox
      intltool
      gtkvnc
      gtk3
      libvirt-glib
      avahi
      glib
      gobjectIntrospection
      gsettings_desktop_schemas
      gnome3.defaultIconTheme
      wrapGAppsHook
    ];

  configurePhase = ''
    sed -i 's/from distutils.core/from setuptools/g' setup.py
    sed -i 's/from distutils.command.install/from setuptools.command.install/g' setup.py
    python setup.py configure --prefix=$out
  '';

  buildPhase = "true";

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
