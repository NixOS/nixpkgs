{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  boost,
  lua,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ansifilter";
  version = "2.22";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "ansifilter";
    tag = finalAttrs.version;
    hash = "sha256-jCgucC5mHkDwVtTKP92RBStxpouQCR7PHWkDt0y+9BM=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    boost
    lua
  ];

  postPatch = ''
    # avoid timestamp non-determinism with '-n'
    substituteInPlace makefile --replace-fail 'gzip -9f' 'gzip -9nf'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "conf_dir=/etc/ansifilter"
  ];

  meta = {
    description = "ANSI sequence filter";
    mainProgram = "ansifilter";
    longDescription = ''
      Ansifilter handles text files containing ANSI terminal escape codes.
      The command sequences may be stripped or be interpreted to generate formatted
      output (HTML, RTF, TeX, LaTeX, BBCode, Pango).
    '';
    homepage = "https://gitlab.com/saalen/ansifilter";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
