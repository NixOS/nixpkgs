{ stdenv, fetchurl, pythonPackages, intltool, libvirt, libxml2Python, curl }:

with stdenv.lib;

let version = "0.600.1"; in

stdenv.mkDerivation rec {
  name = "virtinst-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virtinst/virtinst-${version}.tar.gz";
    sha256 = "db342cf93aae1f23df02001bdb0b0cc2c5bf675dca37b4417f5a79bf5a374716";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto_1_9 twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      # !!! should libvirt be a build-time dependency?  Note that
      # libxml2Python is a dependency of libvirt.py. 
      libvirt libxml2Python urlgrabber
    ];

  buildInputs =
    [ pythonPackages.python 
      pythonPackages.wrapPython
      pythonPackages.mox
      intltool
    ] ++ pythonPath;

  buildPhase = "python setup.py build";

  installPhase =
    ''
       python setup.py install --prefix="$out";
       wrapPythonPrograms
    '';

  meta = {
    homepage = http://virt-manager.org;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [qknight];
    description = "The Virt Install tool (virt-install for short command name, virtinst for package name) is a command line tool which provides an easy way to provision operating systems into virtual machines.";
  };
}
