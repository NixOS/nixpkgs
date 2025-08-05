{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bison,
  flex,
  autoreconfHook,
  openssl,
  db,
  attr,
  perl,
  tcsh,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orangefs";
  version = "2.9.8";

  src = fetchurl {
    url = "http://download.orangefs.org/current/source/orangefs-${finalAttrs.version}.tar.gz";
    hash = "sha256-WJ97bEyOqblrYUJ/kAWtC+JYy0NwK0fZ8wTIEoyiXjA=";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/waltligon/orangefs/commit/f472beb50356bea657d1c32f1ca8a73e4718fd57.patch";
      hash = "sha256-UTUIVBFW+y5P42T7somLi9uDMoLI69Yik9W/3pwLWEk=";
    })
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
    autoreconfHook
  ];
  buildInputs = [
    openssl
    db
    attr
    tcsh
  ];

  postPatch = ''
    # Issue introduced by attr-2.4.48
    substituteInPlace src/apps/user/ofs_setdirhint.c --replace attr/xattr.h sys/xattr.h

    # Do not try to install empty sysconfdir
    substituteInPlace Makefile.in --replace 'install -d $(sysconfdir)' ""

    # perl interpreter needs to be fixed or build fails
    patchShebangs ./src/apps/admin/pvfs2-genconfig

    # symlink points to a location in /usr
    rm ./src/client/webpack/ltmain.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc/orangefs"
    "--enable-shared"
    "--enable-fast"
    "--with-ssl=${lib.getDev openssl}"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # install useful helper scripts
    install examples/keys/pvfs2-gen-keys.sh $out/bin
  '';

  postFixup = ''
    for f in pvfs2-getmattr pvfs2-setmattr; do
      substituteInPlace $out/bin/$f --replace '#!/bin/csh' '#!${tcsh}/bin/tcsh'
    done

    sed -i 's:openssl:${openssl}/bin/openssl:' $out/bin/pvfs2-gen-keys.sh
  '';

  passthru.tests = { inherit (nixosTests) orangefs; };

  meta = {
    description = "Scale-out network file system for use on high-end computing systems";
    homepage = "http://www.orangefs.org/";
    license = with lib.licenses; [
      asl20
      bsd3
      gpl2Only
      lgpl21
      lgpl21Plus
      openldap
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
})
