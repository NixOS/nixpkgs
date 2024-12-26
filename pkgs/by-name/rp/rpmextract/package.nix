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

  meta = with lib; {
    description = "Script to extract RPM archives";
    platforms = platforms.all;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "rpmextract";
  };
}
