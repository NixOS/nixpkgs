{ stdenv, fetchurl, pythonPackages }:

with stdenv.lib;

let version = "2011.1"; in

stdenv.mkDerivation rec {
  name = "openstack-compute-2011.1";

  src = fetchurl {
    url = http://launchpad.net/nova/bexar/2011.1/+download/nova-2011.1.tar.gz;
    sha256 = "1g8f75mzjpkzhqk91hga5wpjh8d0kbc9fxxjk0px0qjk20qrmb45";
  };

  pythonPath = 
    [ pythonPackages.setuptools pythonPackages.eventlet pythonPackages.greenlet
      pythonPackages.gflags pythonPackages.netaddr pythonPackages.sqlalchemy
      pythonPackages.carrot
    ];

  buildInputs =
    [ pythonPackages.python 
      pythonPackages.wrapPython
    ] ++ pythonPath;

  preConfigure = "export HOME=$(pwd)";
  
  buildPhase = "python setup.py build";

  installPhase =
    ''
      p=$(toPythonPath $out)
      export PYTHONPATH=$p:$PYTHONPATH
      mkdir -p $p
      python setup.py install --prefix=$out

      wrapPythonPrograms
    '';

  meta = {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
  };
}
