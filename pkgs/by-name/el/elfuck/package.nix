{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "elfuck";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "timhsutw";
    repo = "elfuck";
    rev = "5e60852b1fc2f1b5eb5d8834152eeffd0f8b3597";
    hash = "sha256-/ZNnuqb9pO+GQcWXSK5lrQY9AcLAMuHWFnFk5Q6yq3c=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp src/elfuck $out/bin
  '';

  meta = with lib; {
    description = "ELF packer for i386";
    downloadPage = "https://github.com/timhsutw/elfuck";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "elfuck";
    platforms = [ "i686-linux" ];
  };
}
