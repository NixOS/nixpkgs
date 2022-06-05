{ lib, stdenv, fetchurl, wxGTK, subversion, apr, aprutil, python3, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "rapidsvn";
  version = "0.12.1";

  src = fetchurl {
    url = "http://www.rapidsvn.org/download/release/${version}/${pname}-${version}.tar.gz";
    sha256 = "1bmcqjc12k5w0z40k7fkk8iysqv4fw33i80gvcmbakby3d4d4i4p";
  };

  buildInputs = [ wxGTK subversion apr aprutil python3 ];

  NIX_CFLAGS_COMPILE = [ "-std=c++14" ];

  configureFlags = [ "--with-svn-include=${subversion.dev}/include"
    "--with-svn-lib=${subversion.out}/lib" ];

  patches = [
    ./fix-build.patch
    # Python 3 compatibility patches
    (fetchpatch {
      url = "https://github.com/RapidSVN/RapidSVN/pull/44/commits/2e26fd5d6a413d6c3a055c17ac4840b95d1537e9.patch";
      hash = "sha256-8acABzscgZh1bfAt35KHfU+nfaiO7P1b+lh34Bj0REI=";
    })
    (fetchpatch {
      url = "https://github.com/RapidSVN/RapidSVN/pull/44/commits/92927af764f92b3731333ed3dba637f98611167a.patch";
      hash = "sha256-4PdShGcfFwxjdI3ygbnKFAa8l9dGERq/xSl54WisgKM=";
    })
    (fetchpatch {
      url = "https://github.com/RapidSVN/RapidSVN/pull/44/commits/3e375f11d94cb8faddb8b7417354a9fb51f304ec.patch";
      hash = "sha256-BUpCMEH7jctOLtJktDUE52bxexfLemLItZ0IgdAnq9g=";
    })
  ];

  meta = {
    description = "Multi-platform GUI front-end for the Subversion revision system";
    homepage = "http://rapidsvn.tigris.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
}
