{
  lib,
  symlinkJoin,
  libcMinimal,
  libpthread,
  libm,
  libresolv,
  librpcsvc,
  i18n_module,
  libutil,
  librt,
  libcrypt,
  version,
}:

symlinkJoin {
  pname = "libc-netbsd";
  inherit version;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  paths =
    lib.concatMap
      (p: [
        (lib.getDev p)
        (lib.getLib p)
        (lib.getMan p)
      ])
      [
        libcMinimal
        libm
        libpthread
        libresolv
        librpcsvc
        i18n_module
        libutil
        librt
        libcrypt
      ];

  postBuild = ''
    rm -r "$out/nix-support"
    fixupPhase
  '';

  # NetBSD's threads are POSIX threads — `libpthread` is joined in above.
  #
  # See the comment on `threadModel` in
  # pkgs/development/compilers/gcc/ng/common/libgcc/default.nix for further
  # details.
  passthru.threadModel = "posix";

  meta.platforms = lib.platforms.netbsd;
}
