{
  lib,
  stdenv,
  fetchurl,
  findutils,
  fixDarwinDylibNames,
  updateAutotoolsGnuConfigScriptsHook,
  sslSupport ? true,
  openssl,
  fetchpatch,

  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "libevent";
  version = "2.1.12";

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "1fq30imk8zd26x8066di3kpc5zyfc5z6frr3zll685zcx4dxxrlj";
  };

  patches = [
    # Don't define BIO_get_init() for LibreSSL 3.5+
    (fetchpatch {
      url = "https://github.com/libevent/libevent/commit/883630f76cbf512003b81de25cd96cb75c6cf0f9.patch";
      sha256 = "sha256-VPJqJUAovw6V92jpqIXkIR1xYGbxIWxaHr8cePWI2SU=";
    })
  ];

  configureFlags = lib.flatten [
    (lib.optional (!sslSupport) "--disable-openssl")
    (lib.optionals static [
      "--disable-shared"
      "--with-pic"
    ])
  ];

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  # libevent_openssl is moved into its own output, so that openssl isn't present
  # in the default closure.
  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional sslSupport "openssl";
  outputBin = "dev";
  propagatedBuildOutputs = [ "out" ] ++ lib.optional sslSupport "openssl";

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs =
    lib.optional sslSupport openssl ++ lib.optional stdenv.hostPlatform.isCygwin findutils;

  doCheck = false; # needs the net

  postInstall = lib.optionalString sslSupport ''
    moveToOutput "lib/libevent_openssl*" "$openssl"
    substituteInPlace "$dev/lib/pkgconfig/libevent_openssl.pc" \
      --replace "$out" "$openssl"
    sed "/^libdir=/s|$out|$openssl|" -i "$openssl"/lib/libevent_openssl.la
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Event notification library";
    mainProgram = "event_rpcgen.py";
    longDescription = ''
      The libevent API provides a mechanism to execute a callback function
      when a specific event occurs on a file descriptor or after a timeout
      has been reached.  Furthermore, libevent also support callbacks due
      to signals or regular timeouts.

      libevent is meant to replace the event loop found in event driven
      network servers.  An application just needs to call event_dispatch()
      and then add or remove events dynamically without having to change
      the event loop.
    '';
    homepage = "https://libevent.org/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
