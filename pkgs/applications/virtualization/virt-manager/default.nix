{ stdenv, fetchurl, pythonPackages, intltool, libxml2Python, curl, python
, makeWrapper, virtinst, pyGtkGlade, pythonDBus, gnome_python, gtkvnc, vte
, gtk3, gobjectIntrospection, libvirt-glib, gsettings_desktop_schemas, glib
, avahi, dconf, spiceSupport ? true, spice_gtk
}:

with stdenv.lib;
with pythonPackages;

buildPythonPackage rec {
  name = "virt-manager-${version}";
  version = "1.0.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virt-manager/${name}.tar.gz";
    sha256 = "1n248kack1fni8y17ysgq5xhvffcgy4l62hnd0zvr4kjw0579qq8";
  };

  propagatedBuildInputs =
    [ eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      urlgrabber virtinst pyGtkGlade pythonDBus gnome_python pygobject3
      libvirt libxml2Python ipaddr vte
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
    ];

  configurePhase = ''
    sed -i 's/from distutils.core/from setuptools/g' setup.py
    sed -i 's/from distutils.command.install/from setuptools.command.install/g' setup.py
    python setup.py configure --prefix=$out
  '';

  buildPhase = "true";

  postInstall = ''
    # GI_TYPELIB_PATH is needed at runtime for GObject stuff to work
    for file in "$out"/bin/*; do
        wrapProgram "$file" \
            --prefix GI_TYPELIB_PATH : $GI_TYPELIB_PATH \
            --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules" \
            --prefix GSETTINGS_SCHEMA_DIR : $out/share/glib-2.0/schemas \
            --prefix XDG_DATA_DIRS : "$out/share:${gtk3}/share:$GSETTINGS_SCHEMAS_PATH:\$XDG_DATA_DIRS"
    done

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
