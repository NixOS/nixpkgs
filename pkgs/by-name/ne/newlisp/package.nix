{
  lib,
  fetchurl,
  stdenv,
  libffi,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newlisp";
  version = "10.7.5";

  src = fetchurl {
    url = "https://www.newlisp.org/downloads/newlisp-${finalAttrs.version}.tgz";
    hash = "sha256-3C0P9lHCsnW8SvOvi6WYUab7bh6t3CCudftgsekBJuw=";
  };

  buildInputs = [
    libffi
    readline
  ];

  configureScript = "./configure-alt";

  doCheck = true;
  checkTarget = "testall";

  meta = {
    description = "Lisp-like, general-purpose scripting language";
    longDescription = ''
      newLISP is a Lisp-like, general-purpose scripting language. It is
      especially well-suited for applications in AI, simulation, natural
      language processing, big data, machine learning and statistics. Because
      of its small resource requirements, newLISP is excellent for embedded
      systems applications. Most of the functions you will ever need are
      already built in. This includes networking functions, support for
      distributed and multicore processing, and Bayesian statistics.
    '';
    homepage = "https://www.newlisp.org/";
    downloadPage = "https://www.newlisp.org/downloads/";
    changelog = "https://www.newlisp.org/downloads/newlisp-${finalAttrs.version}/doc/CHANGES";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "newlisp";
    platforms = lib.platforms.all;
  };
})
