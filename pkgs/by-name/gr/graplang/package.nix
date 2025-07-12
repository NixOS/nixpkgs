{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graplang";
  version = "1.46";

  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://www.lunabase.org/~faber/Vault/software/grap/grap-${finalAttrs.version}.tar.gz";
    hash = "sha512-7n+jLANU/x+wGrpjwYAnf45fQ5M91SwraiCbvUKe6XhWtilhGoT2yTlLkPlTihETTkizLyssW5gj5gbwNHaooA==";
  };

  nativeBuildInputs = [
    flex
    bison
  ];

  meta = with lib; {
    description = "Language for typesetting graphs";
    longDescription = ''
      Grap is an Expressive language for describing graphs and incorporating
      them in typeset documents.  It is implemented as a preprocessor to
      Kernigan's pic language for describing languages, so any system that can
      use pic can use grap. For sure, TeX and groff can use it.
    '';
    homepage = "https://www.lunabase.org/~faber/Vault/software/grap/";
    changelog = "https://github.com/snorerot13/grap/blob/master/CHANGES";
    license = licenses.bsd2;
    maintainers = with maintainers; [ afh ];
    mainProgram = "grap";
  };
})
