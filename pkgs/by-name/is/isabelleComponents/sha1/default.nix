{
  lib,
  stdenv,
  fetchhg,
}:

stdenv.mkDerivation {
  pname = "isabelle-sha1";
  version = "2024";

  src = fetchhg {
    url = "https://isabelle.sketis.net/repos/sha1";
    rev = "0ce12663fe76";
    hash = "sha256-DB/ETVZhbT82IMZA97TmHG6gJcGpFavxDKDTwPzIF80=";
  };

  buildPhase = ''
    CFLAGS="-fPIC -I."
    LDFLAGS="-fPIC -shared"
    $CC $CFLAGS -c sha1.c -o sha1.o
    $CC $LDFLAGS sha1.o -o libsha1.so
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libsha1.so $out/lib/
  '';

  meta = {
    description = "Linter component for Isabelle";
    homepage = "https://github.com/isabelle-prover/isabelle-linter";
    maintainers = with lib.maintainers; [
      jvanbruegge
      sempiternal-aurora
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
