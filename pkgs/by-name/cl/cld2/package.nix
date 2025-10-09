{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
  fetchDebianPatch,
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
    (fetchDebianPatch {
      pname = "cld2";
      version = "0.0.0-git20150806";
      debianRevision = "10";
      patch = "add-cmake-file.patch";
      hash = "sha256-iLacWD4jQxid76pzGpDW3ZJ8Dyaksfj1pNTrU7qSBQM=";
    })
    (fetchpatch {
      name = "fix-narrowing-errors.txt";
      url = "https://github.com/ripjar/cld2/pull/1/commits/79be1adea78f0d376cb793f4dae8e70b100dadcc.patch";
      hash = "sha256-i4WWYBx16kYXZ5IQPACWbS/HGsQysXre1SngYlAfNaM=";
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
