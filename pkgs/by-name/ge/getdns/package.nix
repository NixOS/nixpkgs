{
  lib,
  stdenv,
  fetchurl,
  cmake,
  doxygen,
  libidn2,
  openssl,
  unbound,
  yq,

  enableStubOnly ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "getdns";
  version = "1.7.3";
  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  src = fetchurl {
    url = "https://getdnsapi.net/releases/getdns-${lib.concatStringsSep "-" (lib.splitVersion finalAttrs.version)}/getdns-${finalAttrs.version}.tar.gz";
    # upstream publishes hashes in hex format
    sha256 = "f1404ca250f02e37a118aa00cf0ec2cbe11896e060c6d369c6761baea7d55a2c";
  };

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    libidn2
    openssl
  ]
  ++ lib.optional (!enableStubOnly) unbound;

  cmakeFlags = [ (lib.strings.cmakeBool "ENABLE_STUB_ONLY" enableStubOnly) ];

  # https://github.com/getdnsapi/getdns/issues/517
  postPatch = ''
    substituteInPlace getdns.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  postInstall = "rm -r $out/share/doc";

  meta = {
    description = "Modern asynchronous DNS API";
    longDescription = ''
      getdns is an implementation of a modern asynchronous DNS API; the
      specification was originally edited by Paul Hoffman. It is intended to make all
      types of DNS information easily available to application developers and non-DNS
      experts. DNSSEC offers a unique global infrastructure for establishing and
      enhancing cryptographic trust relations. With the development of this API the
      developers intend to offer application developers a modern and flexible
      interface that enables end-to-end trust in the DNS architecture, and which will
      inspire application developers to implement innovative security solutions in
      their applications.
    '';
    homepage = "https://getdnsapi.net";
    maintainers = with lib.maintainers; [
      leenaars
    ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
