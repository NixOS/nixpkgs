{ stdenv, fetchurl, pythonPackages, intltool, libvirt, curl, openssl, openssh }:

pythonPackages.buildPythonPackage rec {
  name = "nova-${version}";
  version = "12.0.0";
  namePrefix = "";

  PBR_VERSION = "${version}";

  src = fetchurl {
    url = "https://github.com/openstack/nova/archive/${version}.tar.gz";
    sha256 = "175n1znvmy8f5vqvabc2fa4qy8y17685z4gzpq8984mdsdnpv21w";
  };

  # https://github.com/openstack/nova/blob/stable/liberty/requirements.txt
  propagatedBuildInputs = with pythonPackages; [
    pbr sqlalchemy_1_0 boto decorator eventlet jinja2 lxml routes cryptography
    webob greenlet PasteDeploy paste prettytable sqlalchemy_migrate netaddr
    netifaces paramiko Babel iso8601 jsonschema keystoneclient requests2 six
    stevedore websockify rfc3986 os-brick psutil_1 alembic psycopg2 pymysql
    keystonemiddleware

    # oslo components
    oslo-rootwrap oslo-reports oslo-utils oslo-i18n oslo-config oslo-context
    oslo-log oslo-serialization oslo-middleware oslo-db oslo-service oslo-messaging
    oslo-concurrency oslo-versionedobjects

    # clients
    cinderclient neutronclient glanceclient
  ];

  buildInputs = with pythonPackages; [
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
