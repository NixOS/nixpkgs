{
  lib,
  fetchurl,
  net-tools,
  openssl,
  readline,
  stdenv,
  which,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "socat";
  version = "1.8.0.3";

  src = fetchurl {
    url = "http://www.dest-unreach.org/socat/download/socat-${version}.tar.bz2";
    hash = "sha256-AesBc2HZW7OmlB6EC1nkRjo/q/kt9BVO0CsWou1qAJU=";
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

  enableParallelBuilding = true;

  nativeCheckInputs = [
    which
    net-tools
  ];
  doCheck = false; # fails a bunch, hangs

  passthru.tests = lib.optionalAttrs stdenv.buildPlatform.isLinux {
    musl = buildPackages.pkgsMusl.socat;
  };

  meta = {
    description = "Utility for bidirectional data transfer between two independent data channels";
    homepage = "http://www.dest-unreach.org/socat/";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ ryan4yin ];
    mainProgram = "socat";
  };
}
