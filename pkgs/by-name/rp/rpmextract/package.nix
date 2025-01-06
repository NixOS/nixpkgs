{
  lib,
  stdenv,
  rpm,
  cpio,
  substituteAll,
}:

stdenv.mkDerivation {
  name = "rpmextract";

  buildCommand = ''
    install -Dm755 $script $out/bin/rpmextract
  '';

  script = substituteAll {
    src = ./rpmextract.sh;
    isExecutable = true;
    inherit rpm cpio;
    inherit (stdenv) shell;
  };

  meta = {
    description = "Script to extract RPM archives";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ abbradar ];
    mainProgram = "rpmextract";
  };
}
