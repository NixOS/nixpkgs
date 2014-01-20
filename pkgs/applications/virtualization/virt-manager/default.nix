{ stdenv, fetchurl, pythonPackages, intltool, libxml2Python, curl, python
, makeWrapper, virtinst, pyGtkGlade, pythonDBus, gnome_python, gtkvnc, vte
, spiceSupport ? true, spice_gtk
}:

with stdenv.lib;

let version = "0.9.5"; in

stdenv.mkDerivation rec {
  name = "virt-manager-${version}";

  src = fetchurl {
    url = "http://virt-manager.et.redhat.com/download/sources/virt-manager/virt-manager-${version}.tar.gz";
    sha256 = "0gc06cdbq6c2a06l939516lvjii7lr0wng90kqgl1i5q5wlgnajx";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto_1_9 twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      # !!! should libvirt be a build-time dependency?  Note that
      # libxml2Python is a dependency of libvirt.py.
      libvirt libxml2Python urlgrabber virtinst pyGtkGlade pythonDBus gnome_python
      gtkvnc vte
    ] ++ optional spiceSupport spice_gtk;

  buildInputs =
    [ pythonPackages.python
      pythonPackages.wrapPython
      pythonPackages.mox
      pythonPackages.urlgrabber
      intltool
      pyGtkGlade
      pythonDBus
      gnome_python
      gtkvnc
    ] ++ pythonPath;

  buildPhase = "make";

  nativeBuildInputs = [ makeWrapper pythonPackages.wrapPython ];

  # TODO
  # virt-manager     -> import gtk.glade -> No module named glade --> fixed by removing 'pygtk' and by only using pyGtkGlade
  #                  -> import gconf     -> ImportError: No module named gconf
  #                        -> pfad um gtk-2.0 erweitern in virt-manger runner -> /nix/store/hnyxc9i4yz2mc42n44ms13mn8n486s5h-gnome-python-2.28.1/lib/python2.7/site-packages/gtk-2.0
  #                  -> Error starting Virtual Machine Manager: Failed to contact configuration server; the most common cause is a missing or misconfigured D-Bus session bus daemon. See http://projects.gnome.org/gconf/ for information. (Details -  1: GetIOR failed: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.gnome.GConf was not provided by any .service files)

#Traceback (most recent call last):
#  File "/nix/store/y9rcdiv6686sqcv4r39p575s37jzc2cz-virt-manager-0.9.1/share/virt-manager/virt-manager.py", line 383, in <module>
#    main()
#  File "/nix/store/y9rcdiv6686sqcv4r39p575s37jzc2cz-virt-manager-0.9.1/share/virt-manager/virt-manager.py", line 315, in main
#    config = virtManager.config.vmmConfig(appname, appversion, glade_dir)
#  File "/nix/store/y9rcdiv6686sqcv4r39p575s37jzc2cz-virt-manager-0.9.1/share/virt-manager/virtManager/config.py", line 98, in __init__
#    self.conf.add_dir(self.conf_dir, gconf.CLIENT_PRELOAD_NONE)
#GError: Failed to contact configuration server; the most common cause is a missing or misconfigured D-Bus session bus daemon. See http://projects.gnome.org/gconf/ for information. (Details -  1: GetIOR failed: GDBus.Error:org.freedesktop.DBus.Error.ServiceUnknown: The name org.gnome.GConf was not provided by any .service files)
# -> fixed by http://nixos.org/wiki/Solve_GConf_errors_when_running_GNOME_applications & a restart
  # virt-manager-tui -> ImportError: No module named newt_syrup.dialogscreen

  installPhase = ''
    make install

    # A hack, but the most reliable method so far
    echo "#!/usr/bin/env python" | cat - src/virt-manager.py > $out/bin/virt-manager
    echo "#!/usr/bin/env python" | cat - src/virt-manager-tui.py > $out/bin/virt-manager-tui

    wrapPythonPrograms
  '';

  meta = {
    homepage = http://virt-manager.org;
    description = "Desktop user interface for managing virtual machines";
    longDescription = ''
      The virt-manager application is a desktop user interface for managing
      virtual machines through libvirt. It primarily targets KVM VMs, but also
      manages Xen and LXC (linux containers).
    '';
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [qknight];
  };
}
