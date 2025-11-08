{
  lib,
  stdenv,
  fetchFromGitea,
  guile,
  guile-irregex,
}:
stdenv.mkDerivation {
  pname = "guile-srfi-145";
  version = "0-unstable-2023-06-04";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rgherdt";
    repo = "srfi";
    rev = "e598c28eb78e9c3e44f5c3c3d997ef28abb6f32e";
    hash = "sha256-kvM2v/nDou0zee4+qcO5yN2vXt2y3RUnmKA5S9iKFE0=";
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
    cp $src/srfi/srfi-145.scm $site_dir/srfi/
    guild compile --r7rs $site_dir/srfi/srfi-145.scm -o $lib_dir/srfi/srfi-145.go

    runHook postBuild
  '';

  meta = {
    description = "Scheme SRFI-145 implementations in portable R7RS scheme";
    homepage = "https://codeberg.org/rgherdt/srfi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightpp ];
    platforms = guile.meta.platforms;
  };
}
