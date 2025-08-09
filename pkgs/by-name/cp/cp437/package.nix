{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "cp437";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "keaston";
    repo = "cp437";
    rev = "v${version}";
    sha256 = "18f4mnfnyviqclbhmbhix80k823481ypkwbp26qfvhnxdgzbggcc";
  };

  installPhase = ''
    install -Dm755 cp437 -t $out/bin
  '';

  meta = with lib; {
    description = ''
      Emulates an old-style "code page 437" / "IBM-PC" character
      set terminal on a modern UTF-8 terminal emulator
    '';
    homepage = "https://github.com/keaston/cp437";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
    mainProgram = "cp437";
  };
}
