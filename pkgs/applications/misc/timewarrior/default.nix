{ lib, stdenv, fetchFromGitHub, cmake, asciidoctor }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "sha256-qD49NExR0OZ6hgt5ejGiltxF9xkmseJjhJNzEGofnhw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake asciidoctor ];

  dontUseCmakeBuildDir = true;

  meta = with lib; {
    description = "A command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer mrVanDalo ];
    mainProgram = "timew";
    platforms = platforms.linux ++ platforms.darwin;
  };
}

