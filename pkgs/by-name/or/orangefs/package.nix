{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  autoreconfHook,
  openssl,
  db,
  attr,
  perl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orangefs";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "waltligon";
    repo = "orangefs";
    tag = finalAttrs.version;
    hash = "sha256-bWQFr/37dmGyz9wmzGhmBI44CgAhBLlbKGMXf25c7zY=";
  };

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
  ];

  postPatch = ''
    # Issue introduced by attr-2.4.48
    substituteInPlace src/apps/user/ofs_setdirhint.c --replace attr/xattr.h sys/xattr.h

    # Do not try to install empty sysconfdir
    substituteInPlace Makefile.in --replace 'install -d $(sysconfdir)' ""

    # perl interpreter needs to be fixed or build fails
    patchShebangs ./src/apps/admin/pvfs2-genconfig
  '';

  # m4 macros are not in the default search path
  autoreconfFlags = [
    "--install"
    "--force"
    "--verbose"
    "-I"
    "maint/config"
  ];

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
