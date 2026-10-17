{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  makeWrapper,
  guile,
  guile-commonmark,
  guile-fibers,
  guile-gcrypt,
  guile-git,
  guile-gnutls,
  guile-syntax-highlight,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "gitile";
  version = "0.4.0";

  src = fetchgit {
    url = "https://git.lepiller.eu/git/gitile";
    rev = "1feb300c0d3069b1180e62c5e989ac0ed353a248";
    hash = "sha256-sJ8O2L8fYNQ/TXHsNcLQfZUwTte7ILYH0+eeDkmxGPo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    guile
    guile-commonmark
    guile-fibers
    guile-gcrypt
    guile-git
    guile-gnutls
    guile-syntax-highlight
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  # disable the use of upstream hosted cat avatars generator for authors
  postPatch = ''
    substituteInPlace gitile/pages.scm \
       --replace-fail "(p (img (@ (src ,(author-image (commit-author commit))))))" ""
  '';

  postInstall = ''
    wrapProgram $out/bin/gitile \
         --prefix GUILE_LOAD_PATH : $out/${guile.siteDir}:$GUILE_LOAD_PATH \
         --prefix GUILE_LOAD_COMPILED_PATH : $out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH
  '';

  meta = {
    homepage = "https://git.lepiller.eu/gitile";
    description = "Git forge written in Guile";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ abbe ];
    platforms = guile.meta.platforms;
  };
}
