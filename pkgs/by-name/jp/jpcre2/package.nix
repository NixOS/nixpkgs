{
  lib,
  stdenv,
  fetchFromGitHub,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jpcre2";
  version = "10.32.01";
  rev = finalAttrs.version;

  src = fetchFromGitHub {
    owner = "jpcre2";
    repo = "jpcre2";
    tag = finalAttrs.version;
    hash = "sha256-CizjxAiajDLqajZKizMRAk5UEZA+jDeBSldPyIb6Ic8=";
  };

  buildInputs = [ pcre2 ];

  meta = {
    homepage = "https://docs.neuzunix.com/jpcre2/latest/";
    description = "C++ wrapper for PCRE2 Library";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})
