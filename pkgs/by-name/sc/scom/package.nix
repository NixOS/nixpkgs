{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finaAttrs: {
  pname = "scom";
<<<<<<< HEAD
  version = "1.2.3";
=======
  version = "1.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "crash-systems";
    repo = "scom";
    tag = finaAttrs.version;
<<<<<<< HEAD
    hash = "sha256-eFnCXMrks5V6o+0+vMjR8zaCdkc+hC3trSS+pOh4Y6U=";
=======
    hash = "sha256-erHer9oeCFwenaEDk/RWYzGkrqigpwB+RPa+UVxFrOI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Minimal serial communication tool";
    homepage = "https://github.com/crash-systems/scom";
    mainProgram = "scom";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ savalet ];
    platforms = lib.platforms.unix;
  };
})
