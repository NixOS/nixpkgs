{
  stdenv,
  fetchzip,
  mitscheme,
  guile,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-irregex";
  version = "0.9.11";

  src = fetchzip {
    url = "https://synthcode.com/scheme/irregex/irregex-${finalAttrs.version}.tar.gz";
    hash = "sha256-abBCMNsr6GTBOm+eQWuOX8JYx/qMA/V6TwGdYRjznWU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
    mitscheme
  ];

  buildInputs = [
    guile
  ];

  env.GUILE_AUTO_COMPILE = "0";

  buildPhase = ''
    runHook preBuild

    site_dir="$out/share/guile/site/3.0"
    lib_dir="$out/lib/guile/3.0/site-ccache"

    mkdir -p $site_dir/rx/source
    mkdir -p $lib_dir/rx/source

    cp $src/irregex-guile.scm $site_dir/rx/irregex.scm
    cp $src/irregex.scm $site_dir/rx/source/irregex.scm
    cp $src/irregex-utils.scm $site_dir/rx/source/irregex-utils.scm
    guild compile --r7rs $site_dir/rx/irregex.scm -o $lib_dir/rx/irregex.go
    guild compile --r7rs $site_dir/rx/source/irregex.scm -o $lib_dir/rx/source/irregex.go

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "IrRegular Expressions";
    longDescription = ''
      A fully portable and efficient R[4567]RS implementation of regular expressions, supporting
      both POSIX syntax with various (irregular) PCRE extensions, as well as SCSH's SRE syntax, with
      various aliases for commonly used patterns. DFA matching is used when possible, otherwise a
      closure-compiled NFA approach is used. The library makes no assumptions about the encoding of
      strings or range of characters and can thus be used in Unicode-aware Scheme implementations.
      Matching may be performed over standard Scheme strings, or over arbitrarily chunked streams of
      strings.
    '';
    homepage = "https://synthcode.com/scheme/irregex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightpp ];
    platforms = guile.meta.platforms;
  };
})
