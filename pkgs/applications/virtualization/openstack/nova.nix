{ stdenv, fetchurl, python2Packages, openssl, openssh }:

python2Packages.buildPythonApplication rec {
  name = "nova-${version}";
  version = "12.0.0";
  namePrefix = "";

  PBR_VERSION = "${version}";

  src = fetchurl {
    url = "https://github.com/openstack/nova/archive/${version}.tar.gz";
    sha256 = "175n1znvmy8f5vqvabc2fa4qy8y17685z4gzpq8984mdsdnpv21w";
  };

  # otherwise migrate.cfg is not installed
  patchPhase = ''
    echo "graft nova" >> MANIFEST.in

    # remove transient error test, see http://hydra.nixos.org/build/40203534
    rm nova/tests/unit/compute/test_{shelve,compute_utils}.py
  '';

  # https://github.com/openstack/nova/blob/stable/liberty/requirements.txt
  propagatedBuildInputs = with python2Packages; [
    pbr sqlalchemy boto decorator eventlet jinja2 lxml routes cryptography
    webob greenlet PasteDeploy paste prettytable sqlalchemy_migrate netaddr
    netifaces paramiko Babel iso8601 jsonschema keystoneclient requests six
    stevedore websockify rfc3986 os-brick psutil_1 alembic psycopg2 pymysql
    keystonemiddleware MySQL_python

    # oslo components
    oslo-rootwrap oslo-reports oslo-utils oslo-i18n oslo-config oslo-context
    oslo-log oslo-serialization oslo-middleware oslo-db oslo-service oslo-messaging
    oslo-concurrency oslo-versionedobjects

    # clients
    cinderclient neutronclient glanceclient
  ];

  buildInputs = with python2Packages; [
    coverage fixtures mock mox3 subunit requests-mock pillow oslosphinx
    oslotest testrepository testresources testtools tempest-lib bandit
    oslo-vmware pep8 barbicanclient ironicclient openssl openssh
  ];

  postInstall = ''
    cp -prvd etc $out/etc

    # check all binaries don't crash
    for i in $out/bin/*; do
      case "$i" in
      *nova-dhcpbridge*)
         :
         ;;
      *nova-rootwrap*)
         :
         ;;
      *)
         $i --help
         ;;
      esac
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://nova.openstack.org/;
    description = "OpenStack Compute (a.k.a. Nova), a cloud computing fabric controller";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
