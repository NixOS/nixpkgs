{ stdenv, fetchurl, pythonPackages, intltool, libvirt, libxml2Python, curl, python, makeWrapper, virtinst, pyGtkGlade, pythonDBus, gnome_python, gtkvnc}:

with stdenv.lib;

let version = "0.9.1"; in

stdenv.mkDerivation rec {
  name = "virt-manager-${version}";

  src = fetchurl {
    url = "http://virt-manager.et.redhat.com/download/sources/virt-manager/virt-manager-${version}.tar.gz";
    sha256 = "15e064167ba5ff84ce6fc8790081d61890430f2967f89886a84095a23e40094a";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto_1_9 twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      # !!! should libvirt be a build-time dependency?  Note that
      # libxml2Python is a dependency of libvirt.py. 
      libvirt libxml2Python urlgrabber virtinst pyGtkGlade pythonDBus gnome_python gtkvnc
    ];

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

  # patch the runner script in order to make wrapPythonPrograms work and run the program using a syscall
  # example code: /etc/nixos/nixpkgs/pkgs/development/interpreters/spidermonkey/1.8.0-rc1.nix
  customRunner = ./custom_runner.py;

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

  patchPhase = ''
    cat ${customRunner} > src/virt-manager.in
    substituteInPlace "src/virt-manager.in" --replace "THE_CUSTOM_PATH" "$out"
    substituteInPlace "src/virt-manager.in" --replace "THE_CUSTOM_PROGRAM" "virt-manager"
    substituteInPlace "src/virt-manager.in" --replace "PYTHON_EXECUTABLE_PATH" "${python}/bin/python"

    cat ${customRunner} > src/virt-manager-tui.in
    substituteInPlace "src/virt-manager-tui.in" --replace "THE_CUSTOM_PATH" "$out"
    substituteInPlace "src/virt-manager-tui.in" --replace "THE_CUSTOM_PROGRAM" "virt-manager-tui"
    substituteInPlace "src/virt-manager-tui.in" --replace "PYTHON_EXECUTABLE_PATH" "${python}/bin/python"
  '';

  # /etc/nixos/nixpkgs/pkgs/development/python-modules/generic/wrap.sh
  installPhase = ''
    make install
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
