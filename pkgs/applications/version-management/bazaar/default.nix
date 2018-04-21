{ stdenv, fetchurl, python2Packages
, fetchpatch
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
    (fetchpatch {
      url = "https://bazaar.launchpad.net/~brz/brz/trunk/revision/6754";
      sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
      name = "CVE-2017-14176.patch";
    })
  ];
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
