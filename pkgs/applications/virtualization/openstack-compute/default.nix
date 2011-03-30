{ stdenv, fetchurl, pythonPackages, intltool }:

with stdenv.lib;

let version = "2011.1.1"; in

stdenv.mkDerivation rec {
  name = "openstack-compute-${version}";

  src = fetchurl {
    url = "http://launchpad.net/nova/bexar/${version}/+download/nova-${version}.tar.gz";
    sha256 = "0xd7cxn60vzhkvjwnj0i6jfcxaggwwyw2pnhl4qnb759q9hvk1b9";
  };

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto twisted sqlalchemy_migrate
      distutils_extra simplejson readline
    ];

  buildInputs =
    [ pythonPackages.python 
      pythonPackages.wrapPython
      intltool
    ] ++ pythonPath;

  preConfigure =
    ''
      export HOME=$(pwd)

      # Set the built-in state location to something sensible.
      sed -i nova/flags.py \
        -e "/DEFINE.*'state_path'/ s|../|/var/lib/nova|"
    '';
  
  buildPhase = "python setup.py build";

  installPhase =
    ''    
      p=$(toPythonPath $out)
      export PYTHONPATH=$p:$PYTHONPATH
      mkdir -p $p
      python setup.py install --prefix=$out

      # Nova doesn't like to be called ".nova-foo-wrapped" because it
      # computes some stuff from its own argv[0].  So call the wrapped
      # programs ".nova-foo" by overriding wrapProgram.
      wrapProgram() {
          local prog="$1"
          local hidden="$(dirname "$prog")/.$(basename "$prog")"
          mv $prog $hidden
          makeWrapper $hidden $prog "$@"
      }
      
      wrapPythonPrograms
    '';

  meta = {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
  };
}
