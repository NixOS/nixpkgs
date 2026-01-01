{
  fetchurl,
  lib,
  stdenv,
  autoreconfHook,
  libkrb5,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "libtirpc";
  version = "1.3.7";

  src = fetchurl {
    url = "http://git.linux-nfs.org/?p=steved/libtirpc.git;a=snapshot;h=refs/tags/libtirpc-${
<<<<<<< HEAD
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    };sf=tgz";
    hash = "sha256-VGftEr3xzCp8O3oqCjIZozlq599gxN5IsHBRaG37GP4=";
    name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
=======
      lib.replaceStrings [ "." ] [ "-" ] version
    };sf=tgz";
    hash = "sha256-VGftEr3xzCp8O3oqCjIZozlq599gxN5IsHBRaG37GP4=";
    name = "${pname}-${version}.tar.gz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "dev"
  ];

<<<<<<< HEAD
  env.KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";

=======
  KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libkrb5 ];
  strictDeps = true;

  preConfigure = ''
    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  configureFlags = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "LDFLAGS=-Wl,--undefined-version";

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  doCheck = true;

<<<<<<< HEAD
  __structuredAttrs = true;

  meta = {
    homepage = "https://sourceforge.net/projects/libtirpc/";
    description = "Transport-independent Sun RPC implementation (TI-RPC)";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://sourceforge.net/projects/libtirpc/";
    description = "Transport-independent Sun RPC implementation (TI-RPC)";
    license = licenses.bsd3;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    longDescription = ''
      Currently, NFS commands use the SunRPC routines provided by the
      glibc.  These routines do not support IPv6 addresses.  Ulrich
      Drepper, who is the maintainer of the glibc, refuses any change in
      the glibc concerning the RPC.  He wants the RPC to become a separate
      library.  Other OS (NetBSD, FreeBSD, Solarix, HP-UX, AIX) have
      migrated their SunRPC library to a TI-RPC (Transport Independent
      RPC) implementation.  This implementation allows the support of
      other transports than UDP and TCP over IPv4.  FreeBSD provides a
      TI-RPC library ported from NetBSD with improvements.  This library
      already supports IPv6.  So, the FreeBSD release 5.2.1 TI-RPC has
      been ported to replace the SunRPC of the glibc.
    '';
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
