{
  lib,
  fetchurl,
  nettools,
  openssl,
  readline,
  stdenv,
  which,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "socat";
  version = "1.8.0.2";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/${pname}-${version}.tar.bz2";
    hash = "sha256-rcB6nCcjUnz2Vo0vuWVZeUz5wlSkvC7dNvfzeJ6fdiU=";
  };

  postPatch = ''
    patchShebangs test.sh
    substituteInPlace test.sh \
      --replace /bin/rm rm \
      --replace /sbin/ifconfig ifconfig
  '';

  configureFlags =
    lib.optionals (!stdenv.hostPlatform.isLinux) [
      "--disable-posixmq"
    ]
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      "--disable-dccp"
    ];

  buildInputs = [
    openssl
    readline
  ];

  hardeningEnable = [ "pie" ];

  enableParallelBuilding = true;

  nativeCheckInputs = [
    which
    nettools
  ];
  doCheck = false; # fails a bunch, hangs

  passthru.tests = lib.optionalAttrs stdenv.buildPlatform.isLinux {
    musl = buildPackages.pkgsMusl.socat;
  };

  meta = with lib; {
    description = "Utility for bidirectional data transfer between two independent data channels";
    homepage = "http://www.dest-unreach.org/socat/";
    platforms = platforms.unix;
    license = with licenses; [ gpl2Only ];
    maintainers = [ ];
    mainProgram = "socat";
  };
}
