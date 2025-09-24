{
  lib,
  stdenv,
  fetchurl,
  apr,
  scons,
  openssl,
  aprutil,
  zlib,
  libkrb5,
  pkg-config,
  libiconv,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "serf";
  version = "1.3.10";

  src = fetchurl {
    url = "mirror://apache/serf/${pname}-${version}.tar.bz2";
    hash = "sha256-voHvCLqiUW7Np2p3rffe97wyJ+61eLmjO0X3tB3AZOY=";
  };

  nativeBuildInputs = [
    pkg-config
    scons
  ];
  buildInputs = [
    apr
    openssl
    aprutil
    zlib
    libiconv
  ]
  ++ lib.optional (!stdenv.hostPlatform.isCygwin) libkrb5;

  patches = [
    ./scons.patch

    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/libserf/raw/rawhide/f/libserf-1.3.9-errgetfunc.patch";
      hash = "sha256-FQJvXOIZ0iItvbbcu4kR88j74M7fOi7C/0NN3o1/ub4=";
    })
  ];

  prefixKey = "PREFIX=";

  preConfigure = ''
    appendToVar sconsFlags "APR=$(echo ${apr.dev}/bin/*-config)"
    appendToVar sconsFlags "APU=$(echo ${aprutil.dev}/bin/*-config)"
    appendToVar sconsFlags "CC=$CC"
    appendToVar sconsFlags "OPENSSL=${openssl}"
    appendToVar sconsFlags "ZLIB=${zlib}"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isCygwin) ''
    appendToVar sconsFlags "GSSAPI=${libkrb5.dev}"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "HTTP client library based on APR";
    homepage = "https://serf.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      orivej
      raskin
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
