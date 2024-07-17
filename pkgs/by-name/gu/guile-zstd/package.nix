{
  stdenv,
  lib,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
  guile,
  texinfo,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "guile-zstd";
  version = "0.1.1";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "guile-zstd";
    repo = "guile-zstd";
    rev = "v${version}";
    hash = "sha256-IAyDoqb7qHAy666hxs6CCZrFnfwwV8AaR92XlQQ6FLE=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ zstd ];
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A GNU Guile library providing bindings to zstd";
    homepage = "https://notabug.org/guile-zstd/guile-zstd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
