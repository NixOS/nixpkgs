{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "libbs2b";
  version = "3.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/bs2b/${pname}-${version}.tar.bz2";
    sha256 = "0vz442kkjn2h0dlxppzi4m5zx8qfyrivq581n06xzvnyxi5rg6a7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsndfile ];

  configureFlags = [
    # Required for cross-compilation.
    # Prevents linking error with 'undefined reference to rpl_malloc'.
    # I think it's safe to assume that most libcs will properly handle
    # realloc(NULL, size) and treat it like malloc(size).
    "ac_cv_func_malloc_0_nonnull=yes"
  ];
  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://bs2b.sourceforge.net/";
    description = "Bauer stereophonic-to-binaural DSP library";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
