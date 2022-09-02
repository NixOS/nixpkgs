{ lib, stdenv, fetchFromGitHub, cmake, asciidoctor }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "00ydikzmxym5jhv6w1ii12a6zw5ighddbzxsw03xg8yabzzfnvzw";
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

