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
  version = "unstable-2022-02-21";

  src = fetchgit {
    url = "https://git.lepiller.eu/git/gitile";
    rev = "87f1d9794abe140629b8560a54cc6e024182024c";
    hash = "sha256-v9a4y/AxPBCEe8ne9Al+AdJttYRHA7KZlbj9zKTKYfE=";
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

  meta = with lib; {
    homepage = "https://git.lepiller.eu/gitile";
    description = "Git forge written in Guile";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [abbe];
    platforms = guile.meta.platforms;
  };
}
