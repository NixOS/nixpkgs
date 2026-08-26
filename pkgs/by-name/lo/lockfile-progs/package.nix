{
  lib,
  stdenv,
  fetchurl,
  liblockfile,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lockfile-progs";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/lockfile-progs/lockfile-progs_${finalAttrs.version}.tar.xz";
    sha256 = "sha256-KYj7WotAflLiqmKCzkVJf0Zckh1ZETjBAPSJghWETJA=";
  };

  buildInputs = [ liblockfile ];

  preBuild = ''
    patchShebangs .
  '';

  env.NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.cc.isGNU (toString [
      # Needed with GCC 12
      "-Wno-error=format-overflow"
    ])
    + lib.optionalString stdenv.hostPlatform.isDarwin (toString [
      "-Wno-error=c23-extensions"
    ]);

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/man/man1
    install bin/* $out/bin
    install man/*.1 $out/man/man1
    runHook postInstall
  '';

  meta = {
    description = "Programs for locking and unlocking files and mailboxes";
    homepage = "http://packages.debian.org/sid/lockfile-progs";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
