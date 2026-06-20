{
  lib,
  fetchgit,
  stdenv,
  guile,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-colorized";
  version = "0-unstable-2019-12-05";

  src = fetchgit {
    url = "https://gitlab.com/NalaGinrut/guile-colorized";
    rev = "1625a79f0e31849ebd537e2a58793fb45678c58f";
    hash = "sha256-MxRFt3dPOBA/u2RbdnwWCfS6qjnVYtiuV7K+B6SFp4w=";
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
