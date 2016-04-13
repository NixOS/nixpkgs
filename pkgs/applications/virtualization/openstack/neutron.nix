{ stdenv, fetchurl, pythonPackages, xmlsec, which, dnsmasq }:

pythonPackages.buildPythonApplication rec {
  name = "neutron-${version}";
  version = "7.0.0";
  namePrefix = "";

  PBR_VERSION = "${version}";

  src = fetchurl {
    url = "https://github.com/openstack/neutron/archive/${version}.tar.gz";
    sha256 = "02ll081xly7zfjmgkal81fy3aplbnn5zgx8xfy3yy1nv3kfnyi40";
  };

  # https://github.com/openstack/neutron/blob/stable/liberty/requirements.txt
  propagatedBuildInputs = with pythonPackages; [
   pbr paste PasteDeploy routes debtcollector eventlet greenlet httplib2 requests2
   jinja2 keystonemiddleware netaddr retrying sqlalchemy webob alembic six
   stevedore pecan ryu networking-hyperv MySQL_python

   # clients
   keystoneclient neutronclient novaclient

   # oslo components
   oslo-concurrency oslo-config oslo-context oslo-db oslo-i18n oslo-log oslo-messaging
   oslo-middleware oslo-policy oslo-rootwrap oslo-serialization oslo-service oslo-utils
   oslo-versionedobjects
  ];

  # make sure we include migrations
  prePatch = ''
    echo "graft neutron" >> MANIFEST.in
    substituteInPlace etc/neutron/rootwrap.d/dhcp.filters --replace "/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"
  '';
  patches = [ ./neutron-iproute-4.patch ];

  buildInputs = with pythonPackages; [
    cliff coverage fixtures mock subunit requests-mock oslosphinx testrepository
    testtools testresources testscenarios webtest oslotest os-testr tempest-lib
    ddt pep8
  ];

  postInstall = ''
    # requires extra optional dependencies
    # TODO: package networking_mlnx, networking_vsphere, bsnstacklib, XenAPI
    rm $out/bin/{neutron-mlnx-agent,neutron-ovsvapp-agent,neutron-restproxy-agent,neutron-rootwrap-xen-dom0}

    # check all binaries don't crash
    for i in $out/bin/*; do
      case "$i" in
      *neutron-pd-notify|*neutron-rootwrap-daemon|*neutron-rootwrap)
        :
        ;;
      *)
         $i --help
      esac
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://neutron.openstack.org/;
    description = "Virtual network service for Openstack";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
