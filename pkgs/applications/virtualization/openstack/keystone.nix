{ stdenv, fetchurl, python2Packages, xmlsec, which, openssl }:

python2Packages.buildPythonApplication rec {
  name = "keystone-${version}";
  version = "8.0.0";
  namePrefix = "";

  PBR_VERSION = "${version}";

  src = fetchurl {
    url = "https://github.com/openstack/keystone/archive/${version}.tar.gz";
    sha256 = "1xbrs7xgwjzrs07zyxxcl2lq18dh582gd6lx1zzzji8c0qmffy0z";
  };

  # remove on next version bump
  patches = [ ./remove-oslo-policy-tests.patch ];

  # https://github.com/openstack/keystone/blob/stable/liberty/requirements.txt
  propagatedBuildInputs = with python2Packages; [
    pbr webob eventlet greenlet PasteDeploy paste routes cryptography six
    sqlalchemy sqlalchemy_migrate stevedore passlib keystoneclient memcached
    keystonemiddleware oauthlib pysaml2 dogpile_cache jsonschema pycadf msgpack
    xmlsec MySQL_python

    # oslo
    oslo-cache oslo-concurrency oslo-config oslo-context oslo-messaging oslo-db
    oslo-i18n oslo-log oslo-middleware oslo-policy oslo-serialization oslo-service
    oslo-utils
  ];

  buildInputs = with python2Packages; [
    coverage fixtures mock subunit tempest-lib testtools testrepository
    ldap ldappool webtest requests oslotest pep8 pymongo which
  ];

  makeWrapperArgs = ["--prefix PATH : '${openssl.bin}/bin:$PATH'"];

  postInstall = ''
    # install .ini files
    mkdir -p $out/etc
    cp etc/* $out/etc

    # check all binaries don't crash
    for i in $out/bin/*; do
      $i --help
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://keystone.openstack.org/;
    description = "Authentication, authorization and service discovery mechanisms via HTTP";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
