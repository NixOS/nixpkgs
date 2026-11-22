{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  guile-irregex,
}:
stdenv.mkDerivation {
  pname = "guile-srfi-180";
  version = "0-unstable-2025-08-11";

  src = fetchFromCodeberg {
    owner = "rgherdt";
    repo = "srfi";
    rev = "1f78a684e73c8d82fdd116716e341bc177e8d229";
    hash = "sha256-mVIAg3QrH6+0VFWZ22KHGhxMn8lRYHj154b7YQf+maE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    guile
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    guile-irregex
  ];

  preConfigure = ''
    export GUILE_AUTO_COMPILE=0
  '';

  buildPhase = ''
    runHook preBuild

    site_dir="$out/share/guile/site/3.0"
    lib_dir="$out/lib/guile/3.0/site-ccache"

    export GUILE_LOAD_PATH=.:$site_dir:...:$GUILE_LOAD_PATH
    export GUILE_LOAD_COMPILED_PATH=.:$lib_dir:...:$GUILE_LOAD_COMPILED_PATH

    mkdir -p $site_dir/srfi
    cp $src/srfi/srfi-180.scm $site_dir/srfi
    cp -R $src/srfi/srfi-180/ $site_dir/srfi
    guild compile --r7rs $site_dir/srfi/srfi-180/helpers.scm -o $lib_dir/srfi/srfi-180/helpers.go
    guild compile --r7rs $site_dir/srfi/srfi-180.scm -o $lib_dir/srfi/srfi-180.go

    runHook postBuild
  '';

  meta = {
    description = "Scheme SRFI-180 implementations in portable R7RS scheme";
    homepage = "https://codeberg.org/rgherdt/srfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightpp ];
    platforms = guile.meta.platforms;
  };
}
