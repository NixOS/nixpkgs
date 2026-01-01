{
  lib,
  stdenv,
  rpm,
  cpio,
  replaceVarsWith,
}:

stdenv.mkDerivation {
  name = "rpmextract";

  buildCommand = ''
    install -Dm755 $script $out/bin/rpmextract
  '';

  script = replaceVarsWith {
    src = ./rpmextract.sh;
    isExecutable = true;
    replacements = {
      inherit rpm cpio;
      inherit (stdenv) shell;
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Script to extract RPM archives";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Script to extract RPM archives";
    platforms = platforms.all;
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "rpmextract";
  };
}
