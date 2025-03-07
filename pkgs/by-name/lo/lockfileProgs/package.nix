{
  lib,
  stdenv,
  fetchurl,
  liblockfile,
}:

stdenv.mkDerivation rec {
  pname = "lockfile-progs";
  version = "0.1.19";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/lockfile-progs/lockfile-progs_${version}.tar.gz";
    sha256 = "sha256-LFcEsByPR0+CkheA5Fkqknsr9qbXYWNUpsXXzVZkhX4=";
  };

  buildInputs = [ liblockfile ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU (toString [
    # Needed with GCC 12
    "-Wno-error=format-overflow"
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

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
  };
}
