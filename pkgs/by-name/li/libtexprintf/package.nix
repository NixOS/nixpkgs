{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "libtexprintf";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "bartp5";
    repo = "libtexprintf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OXDcohfSfik0H1MpoznN267OVTYkW75N+TIF6lRRvZ0=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  strictDeps = true;

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/bartp5/libtexprintf";
    description = "Printf-style formatted output routines with TeX-like syntax support";
    longDescription = ''
      libtexprintf provides tools to pretty-print math in mono-space fonts
      using TeX-like syntax, producing UTF-8 encoded output. It includes the
      utftex command-line program and a C library that applications can link
      against for printf-style formatted math output. Inspired by asciiTeX,
      it supports substantially more TeX syntax via extensive Unicode tables
      mapping LaTeX commands to Unicode symbols.
    '';
    changelog = "https://github.com/bartp5/libtexprintf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "utftex";
    platforms = lib.platforms.unix;
  };
})
