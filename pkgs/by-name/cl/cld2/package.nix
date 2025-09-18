{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "cld2";
  version = "0-unstable-2015-08-21";

  src = fetchFromGitHub {
    owner = "CLD2Owners";
    repo = "cld2";
    rev = "b56fa78a2fe44ac2851bae5bf4f4693a0644da7b";
    hash = "sha256-YhXs45IbriKWKULguZM4DgfV/Fzr73VHxA1pFTXCyv8=";
  };

  patches = [
    (fetchpatch {
      name = "add-cmakelists.txt";
      url = "https://github.com/CLD2Owners/cld2/pull/65/commits/9cfac02c2ac7802ab7079560b38a474473c45f51.patch";
      hash = "sha256-uOjmUk8kMFl+wED44ErXoLRyblhgDwFx9K1Wj65Omh8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/CLD2Owners/cld2";
    description = "Compact Language Detector 2";
    longDescription = ''
      CLD2 probabilistically detects over 80 languages in Unicode UTF-8 text,
      either plain text or HTML/XML. Legacy encodings must be converted to valid
      UTF-8 by the caller. For mixed-language input, CLD2 returns the top three
      languages found and their approximate percentages of the total text bytes
      (e.g. 80% English and 20% French out of 1000 bytes of text means about 800
      bytes of English and 200 bytes of French). Optionally, it also returns a
      vector of text spans with the language of each identified. This may be
      useful for applying different spelling-correction dictionaries or
      different machine translation requests to each span. The design target is
      web pages of at least 200 characters (about two sentences); CLD2 is not
      designed to do well on very short text, lists of proper names, part
      numbers, etc.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.all;
  };
}
