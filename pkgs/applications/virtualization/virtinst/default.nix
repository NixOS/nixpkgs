{ stdenv, fetchurl, pythonPackages, intltool, libxml2Python, curl }:

with stdenv.lib;

let version = "0.600.4"; in

stdenv.mkDerivation rec {
  name = "virtinst-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/virtinst/virtinst-${version}.tar.gz";
    sha256 = "175laiy49dni8hzi0cn14bbsdsigvgr9h6d9z2bcvbpa29spldvf";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr carrot routes
      PasteDeploy m2crypto ipy twisted
      distutils_extra simplejson readline glanceclient cheetah lockfile httplib2
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
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [qknight];
    description = "Command line tool which provides an easy way to provision operating systems into virtual machines";
  };
}
