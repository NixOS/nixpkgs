{
  lib,
  clangStdenv,
  fetchurl,
  makeWrapper,

  expat,
  libressl,
  cacert,
  openrsync,
  zlib,
}:
clangStdenv.mkDerivation (finalAttrs: {
  pname = "rpki-client";
  version = "9.8";

  src = fetchurl {
    url = "mirror://openbsd/rpki-client/rpki-client-${finalAttrs.version}.tar.gz";
    hash = "sha256-QpIKrFr9CZYXP7n3hIaRosSd0jTk8QR4gIwapHViCGE=";
  };

  nativeBuildInputs = [
    # We need the openrsync binary as a native build input so we can make the
    # ./configure script happy.
    openrsync

    makeWrapper
  ];

  buildInputs = [
    # We need OpenSSL and libtls, both provided by LibreSSL.
    libressl

    expat
    zlib
  ];

  # Override the prefix during the build because the binary would otherwise
  # contain hard-coded paths to the nix store for mutable resources, such as
  # sockets or cache.
  buildFlags = [ "prefix=" ];

  # Create a wrapper that includes openrsync in the path, as rpki-client invokes
  # openrsync for syncing purposes.
  postFixup = ''
    wrapProgram $out/bin/rpki-client  \
      --prefix PATH : ${lib.makeBinPath [ openrsync ]}
  '';

  strictDeps = true;
  __structuredAttrs = true;
  meta = {
    description = "Free implementation of the Resource Public Key Infrastructure (RPKI) for Relying Parties (RP) to facilitate validation of BGP announcements.";
    license = lib.licenses.isc;
    homepage = "http://www.rpki-client.org/";
    maintainers = with lib.maintainers; [ cvengler ];
    platforms = lib.platforms.all;
  };
})
