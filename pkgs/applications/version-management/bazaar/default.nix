{ stdenv, fetchurl, python2Packages
, withSFTP ? true
 }:

python2Packages.buildPythonApplication rec {
  version = "2.7";
  release = ".0";
  name = "bazaar-${version}${release}";

  src = fetchurl {
    url = "https://launchpad.net/bzr/${version}/${version}${release}/+download/bzr-${version}${release}.tar.gz";
    sha256 = "1cysix5k3wa6y7jjck3ckq3abls4gvz570s0v0hxv805nwki4i8d";
  };

  doCheck = false;

  propagatedBuildInputs = []
  ++ stdenv.lib.optionals withSFTP [ python2Packages.paramiko ];

  patches = [
    # Bazaar can't find the certificates alone
    ./add_certificates.patch
    ./CVE-2017-14176.patch
  ];
  postPatch = ''
    substituteInPlace bzrlib/transport/http/_urllib2_wrappers.py \
      --subst-var-by certPath /etc/ssl/certs/ca-certificates.crt
  '';

  meta = with stdenv.lib; {
    homepage = http://bazaar-vcs.org/;
    description = "A distributed version control system that Just Works";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
