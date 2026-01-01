{
  lib,
  stdenv,
  fetchFromGitea,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
<<<<<<< HEAD
  version = "1.0.1-unstable-2025-02-12";
=======
  version = "1.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "dev86";
<<<<<<< HEAD
    rev = "0332db1ceb238fa7f98603cdf4223a1d839d4b31";
    hash = "sha256-f6C7ykOmOHwxeMsF1Wm81FBBJNwTP0cF4+mFMzsc208=";
  };

  patches = [
    # Fix for GCC 15/C23 by de-K&R-ing function definitions and adding
    # missing parameters to function declarations where necessary.
    ./unproto-c23-compatibility.patch
  ];

=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-xeOtESc0X7RZWCIpNZSHE8au9+opXwnHsAcayYLSX7w=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://codeberg.org/jbruchon/dev86";
    description = "C compiler, assembler and linker environment for the production of 8086 executables";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
