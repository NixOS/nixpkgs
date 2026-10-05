{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libdht";
  version = "0.28";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jech";
    repo = "dht";
    tag = "dht-${finalAttrs.version}";
    hash = "sha256-ThatRVb+ykOvYbpEj7gr9iDbQKE2BSBAChEb5EqH9Fc=";
  };

  strictDeps = true;

  # Upstream ships a Makefile that builds a test binary, not a
  # library, so build the shared object directly. dht.c leaves four
  # symbols for the application to supply; -shared allows that.
  buildPhase = ''
    runHook preBuild
    $CC $NIX_CFLAGS_COMPILE -fPIC -Wall -c -o dht.o dht.c
    $CC -shared -Wl,-soname,libdht.so.0 -o libdht.so.0 dht.o
    runHook postBuild
  '';

  # No install target in upstream's Makefile either.
  installPhase = ''
    runHook preInstall
    install -Dm755 libdht.so.0 $out/lib/libdht.so.0
    ln -s libdht.so.0 $out/lib/libdht.so
    install -Dm644 dht.h $out/include/dht/dht.h
    runHook postInstall
  '';

  meta = {
    description = "BitTorrent DHT library";
    homepage = "https://www.irif.fr/~jch/software/bittorrent/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      dvn0
    ];
  };
})
