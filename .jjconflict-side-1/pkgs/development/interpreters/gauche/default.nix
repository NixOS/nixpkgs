{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  gaucheBootstrap,
  pkg-config,
  texinfo,
  libiconv,
  gdbm,
  openssl,
  zlib,
  mbedtls,
  cacert,
  CoreServices,
}:

stdenv.mkDerivation rec {
  pname = "gauche";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "shirok";
    repo = pname;
    rev = "release${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-M2vZqTMkob+WxUnCo4NDxS4pCVNleVBqkiiRp9nG/KA=";
  };

  nativeBuildInputs = [
    gaucheBootstrap
    pkg-config
    texinfo
    autoreconfHook
  ];

  buildInputs = [
    libiconv
    gdbm
    openssl
    zlib
    mbedtls
    cacert
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  autoreconfPhase = ''
    ./DIST gen
  '';

  postPatch = ''
    substituteInPlace ext/package-templates/configure \
      --replace "#!/usr/bin/env gosh" "#!$out/bin/gosh"
    patchShebangs .
  '';

  configureFlags = [
    "--with-iconv=${libiconv}"
    "--with-dbm=gdbm"
    "--with-zlib=${zlib}"
    "--with-ca-bundle=${cacert}/etc/ssl/certs/ca-bundle.crt"
    # TODO: Enable slib
    #       Current slib in nixpkgs is specialized to Guile
    # "--with-slib=${slibGuile}/lib/slib"
  ];

  enableParallelBuilding = true;

  # TODO: Fix tests that fail in sandbox build
  doCheck = false;

  meta = with lib; {
    description = "R7RS Scheme scripting engine";
    homepage = "https://practical-scheme.net/gauche/";
    mainProgram = "gosh";
    maintainers = with maintainers; [ mnacamura ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
