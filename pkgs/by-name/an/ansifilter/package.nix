{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ansifilter";
  version = "2.23";

  src = fetchFromGitLab {
    owner = "saalen";
    repo = "ansifilter";
    tag = finalAttrs.version;
    hash = "sha256-mWqpHfTzVMCHPnDFZ26rQusEWKxaMjQxl8xwDyiLBrc=";
  };

  nativeBuildInputs = [
    pkg-config
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
