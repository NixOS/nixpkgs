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

symlinkJoin rec {
  name = "${pname}-${version}";
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

  meta.platforms = lib.platforms.netbsd;
}
