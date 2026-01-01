{
<<<<<<< HEAD
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
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
=======
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  boost,
  lua,
}:

stdenv.mkDerivation rec {
  pname = "ansifilter";
  version = "2.22";

  src = fetchurl {
    url = "http://www.andre-simon.de/zip/ansifilter-${version}.tar.bz2";
    hash = "sha256-zP9BynQLgTv5EDhotQAPQkPTKnUwTqkpohTEm5Q+zJM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    lua
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    # avoid timestamp non-determinism with '-n'
<<<<<<< HEAD
    substituteInPlace makefile --replace-fail 'gzip -9f' 'gzip -9nf'
=======
    substituteInPlace makefile --replace 'gzip -9f' 'gzip -9nf'
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "conf_dir=/etc/ansifilter"
  ];

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Tool to convert ANSI to other formats";
    mainProgram = "ansifilter";
    longDescription = ''
      Tool to remove ANSI or convert them to another format
      (HTML, TeX, LaTeX, RTF, Pango or BBCode)
    '';
    homepage = "http://www.andre-simon.de/doku/ansifilter/en/ansifilter.html";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
