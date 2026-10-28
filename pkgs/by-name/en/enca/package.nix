{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
  recode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enca";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "Project-OSS-Revival";
    repo = "enca";
    tag = finalAttrs.version;
    hash = "sha256-TMWAGT3iY/ND8pB4THU4PbBGpb8EfT6z+peT8T6mp4o=";
  };

  buildInputs = [
    recode
    libiconv
  ];

  meta = {
    changelog = "https://github.com/Project-OSS-Revival/enca/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Detects the encoding of text files and reencodes them";
    homepage = "https://cihar.com/software/enca/";
    longDescription = ''
      Enca detects the encoding of text files, on the basis of knowledge
      of their language. It can also convert them to other encodings,
      allowing you to recode files without knowing their current encoding.
      It supports most of Central and East European languages, and a few
      Unicode variants, independently on language.
    '';

    license = lib.licenses.gpl2Only;

  };
})
