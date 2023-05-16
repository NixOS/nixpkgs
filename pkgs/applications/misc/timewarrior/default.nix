<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, cmake, asciidoctor, installShellFiles }:
=======
{ lib, stdenv, fetchFromGitHub, cmake, asciidoctor }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  nativeBuildInputs = [ cmake asciidoctor installShellFiles ];

  dontUseCmakeBuildDir = true;

  postInstall = ''
    installShellCompletion --cmd timew \
      --bash completion/timew-completion.bash
  '';

=======
  nativeBuildInputs = [ cmake asciidoctor ];

  dontUseCmakeBuildDir = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer mrVanDalo ];
    mainProgram = "timew";
    platforms = platforms.linux ++ platforms.darwin;
  };
}

