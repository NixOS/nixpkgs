{ stdenv, mkDerivation, lib, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config
, libtool, openssl, qtbase, qttools, sphinx }:

mkDerivation rec {
  pname = "xca";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner  = "chris2511";
    repo   = "xca";
    rev    = "RELEASE.${version}";
    sha256 = "04z0mmjsry72nvib4icmwh1717y4q9pf2gr68ljrzln4vv4ckpwk";
  };

  # Adaptions to stay OpenSSL 3.0 compatible
  patches = [ (fetchpatch {
    url = "https://github.com/chris2511/xca/commit/f5ac099e948ea354deac75ff9fa09d51453476e1.patch";
    hash = "sha256-4rRO2y9hZq879HTsgBgbXGRYEcgfG4niJKyK3l3PMZ8=";
  }) ];

  buildInputs = [ libtool openssl qtbase ];

  nativeBuildInputs = [ autoreconfHook pkg-config qttools sphinx ];

  # Needed for qcollectiongenerator (see https://github.com/NixOS/nixpkgs/pull/92710)
  QT_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}";

  enableParallelBuilding = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "An x509 certificate generation tool, handling RSA, DSA and EC keys, certificate signing requests (PKCS#10) and CRLs";
    homepage    = "https://hohnstaedt.de/xca/";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    platforms   = platforms.all;
  };
}
