{
  lib,
  fetchgit,
  stdenv,
  guile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-colorized";
  version = "0-unstable-2026-06-24";

  src = fetchgit {
    url = "https://gitlab.com/NalaGinrut/guile-colorized";
    rev = "f9dfbde0cf0a7c72d29ad9efff22a69af85f0894";
    hash = "sha256-RNQRePn3p2ItxrY9LYFK7sKBPCEOjUU0Ztt418XgA2I=";
  };

  strictDeps = true;

  nativeBuildInputs = [ guile ];
  buildInputs = [ guile ];

  preConfigure = ''
    export GUILE_AUTO_COMPILE=0
  '';

  buildPhase = ''
    runHook preBuild

    site_dir="$out/share/guile/3.0"
    lib_dir="$out/lib/guile/3.0/site-ccache"

    export GUILE_LOAD_PATH=.:$site_dir:...:$GUILE_LOAD_PATH
    export GUILE_LOAD_COMPILED_PATH=.:$lib_dir:...:$GUILE_LOAD_COMPILE

    mkdir -p $site_dir/ice-9
    cp $src/ice-9/colorized.scm $site_dir/ice-9
    guild compile $site_dir/ice-9/colorized.scm -o $lib_dir/ice-9/colorized.go

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "Colorized REPL for GNU Guile";
    homepage = "https://gitlab.com/NalaGinrut/guile-colorized/";
    license = lib.licenses.gpl3Plus;
    platforms = guile.meta.platforms;
    maintainers = with lib.maintainers; [ nemin ];
  };
})
