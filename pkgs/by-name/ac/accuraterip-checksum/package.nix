{
  lib,
  stdenv,
  fetchFromGitHub,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "accuraterip-checksum";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "leo-bogert";
    repo = "accuraterip-checksum";
    rev = "version${version}";
    sha256 = "1a6biy78jb094rifazn4a2g1dlhryg5q8p8gwj0a60ipl0vfb9bj";
  };

  buildInputs = [ libsndfile ];

  installPhase = ''
    runHook preInstall

    install -D -m755 accuraterip-checksum "$out/bin/accuraterip-checksum"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Program for computing the AccurateRip checksum of singletrack WAV files";
    homepage = "https://github.com/leo-bogert/accuraterip-checksum";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = with platforms; linux;
    mainProgram = "accuraterip-checksum";
  };
}
