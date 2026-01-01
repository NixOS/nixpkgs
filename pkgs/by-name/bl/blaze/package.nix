{
  lib,
  stdenv,
  fetchFromBitbucket,
  cmake,
  blas,
  lapack-reference,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blaze";
  version = "3.8.2";

  src = fetchFromBitbucket {
    owner = "blaze-lib";
    repo = "blaze";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jl9ZWFqBvLgQwCoMNX3g7z02yc7oYx+d6mbyLBzBJOs=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    lapack-reference
  ];

<<<<<<< HEAD
  meta = {
    description = "High performance C++ math library";
    homepage = "https://bitbucket.org/blaze-lib/blaze";
    license = with lib.licenses; [ bsd3 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "High performance C++ math library";
    homepage = "https://bitbucket.org/blaze-lib/blaze";
    license = with licenses; [ bsd3 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
