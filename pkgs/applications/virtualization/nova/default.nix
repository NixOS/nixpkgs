{ stdenv, fetchurl, pythonPackages, intltool, libvirt, libxml2Python, curl, novaclient }:

with stdenv.lib;

let version = "2011.2"; in

stdenv.mkDerivation rec {
  name = "nova-${version}";

  src = fetchurl {
    url = "http://launchpad.net/nova/cactus/${version}/+download/nova-${version}.tar.gz";
    sha256 = "1s2w0rm332y9x34ngjz8sys9sbldg857rx9d6r3nb1ik979fx8p7";
  };

  patches =
    [ ./convert.patch ];

  pythonPath = with pythonPackages;
    [ setuptools eventlet greenlet gflags netaddr sqlalchemy carrot routes
      paste_deploy m2crypto ipy boto_1_9 twisted sqlalchemy_migrate
      distutils_extra simplejson readline glance cheetah lockfile httplib2
      # !!! should libvirt be a build-time dependency?  Note that
      # libxml2Python is a dependency of libvirt.py.
      libvirt libxml2Python
      novaclient
    ];

  buildInputs =
    [ pythonPackages.python
      pythonPackages.wrapPython
      pythonPackages.mox
      intltool
    ] ++ pythonPath;

  PYTHON_EGG_CACHE = "`pwd`/.egg-cache";

  preConfigure =
    ''
      # Set the built-in state location to something sensible.
      sed -i nova/flags.py \
        -e "/DEFINE.*'state_path'/ s|../|/var/lib/nova|"

      substituteInPlace nova/virt/images.py --replace /usr/bin/curl ${curl}/bin/curl

      substituteInPlace nova/api/ec2/cloud.py \
        --replace 'sh genrootca.sh' $out/libexec/nova/genrootca.sh
    '';

  buildPhase = "python setup.py build";

  installPhase =
    ''
      p=$(toPythonPath $out)
      export PYTHONPATH=$p:$PYTHONPATH
      mkdir -p $p
      python setup.py install --prefix=$out

      # Nova doesn't like to be called ".nova-foo-wrapped" because it
      # computes some stuff from its own argv[0].  So put the wrapped
      # programs in $out/libexec under their original names.
      mkdir -p $out/libexec/nova

      wrapProgram() {
          local prog="$1"
          local hidden=$out/libexec/nova/$(basename "$prog")
          mv $prog $hidden
          makeWrapper $hidden $prog "$@"
      }

      wrapPythonPrograms

      cp -prvd etc $out/etc

      # Nova makes some weird assumptions about where to find its own
      # programs relative to the Python directory.
      ln -sfn $out/bin $out/lib/${pythonPackages.python.libPrefix}/site-packages/bin

      # Install the certificate generation script.
      cp nova/CA/genrootca.sh $out/libexec/nova/
      cp nova/CA/openssl.cnf.tmpl $out/libexec/nova/

      # Allow nova-manage etc. to find the proper configuration file.
      ln -s /etc/nova/nova.conf $out/libexec/nova/nova.conf
    '';

  doCheck = false; # !!! fix

  checkPhase = "python setup.py test";

  meta = {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
    broken = true;
  };
}
