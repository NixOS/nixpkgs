{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "2.7";
  release = ".0";
  name = "bazaar-${version}${release}";

  src = fetchurl {
    url = "https://launchpad.net/bzr/${version}/${version}${release}/+download/bzr-${version}${release}.tar.gz";
    sha256 = "1cysix5k3wa6y7jjck3ckq3abls4gvz570s0v0hxv805nwki4i8d";
  };

  # Readline support is needed by bzrtools.
  propagatedBuildInputs = [ pythonPackages.python.modules.readline ];

  doCheck = false;

  # Bazaar can't find the certificates alone
  patches = [ ./add_certificates.patch ];
  postPatch = ''
    substituteInPlace bzrlib/transport/http/_urllib2_wrappers.py \
      --subst-var-by certPath /etc/ssl/certs/ca-certificates.crt
  '';

  meta = {
    homepage = http://bazaar-vcs.org/;
    description = "A distributed version control system that Just Works";
    platforms = stdenv.lib.platforms.unix;
  };
}
