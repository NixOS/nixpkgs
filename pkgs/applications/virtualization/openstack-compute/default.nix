{ stdenv, fetchurl, python, setuptools, pythonPackages }:

let version = "2011.1"; in

stdenv.mkDerivation {
  name = "openstack-compute-2011.1";

  src = fetchurl {
    url = http://launchpad.net/nova/bexar/2011.1/+download/nova-2011.1.tar.gz;
    sha256 = "1g8f75mzjpkzhqk91hga5wpjh8d0kbc9fxxjk0px0qjk20qrmb45";
  };

  buildInputs =
    [ python setuptools pythonPackages.gflags pythonPackages.netaddr pythonPackages.eventlet
    ];

  preConfigure = "export HOME=$(pwd)";
  
  buildPhase = "python setup.py build";

  installPhase =
    ''
      p=$(toPythonPath $out)
      export PYTHONPATH=$p:$PYTHONPATH
      mkdir -p $p
      python setup.py install --prefix=$out
    '';

  meta = {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
  };
}
