{ lib, stdenv, fetchFromGitHub, cmake, asciidoctor, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    sha256 = "sha256-0obIMnPBvMO30o+qXqwtINNRobBR6cFO65B/xjVt+2w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake asciidoctor installShellFiles ];

  dontUseCmakeBuildDir = true;

  postInstall = ''
    installShellCompletion --cmd timew \
      --bash completion/timew-completion.bash
  '';

  meta = with lib; {
    description = "A command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer mrVanDalo ];
    mainProgram = "timew";
    platforms = platforms.linux ++ platforms.darwin;
  };
}

