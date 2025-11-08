{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "bash-git-prompt";
  version = "2.7.1-unstable-2025-04-23";

  src = fetchFromGitHub {
    owner = "magicmonty";
    repo = "bash-git-prompt";
    rev = "e733ada3e93fd9fdb6e9d1890e38e6e523522da7";
    hash = "sha256-6uUoYSjpGJGOgnLiIR0SdmLZKPG4GNB+e2Y9HpJUODQ=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    # Copy all shell scripts
    cp *.sh $out/

    # Copy fish script
    cp *.fish $out/

    # Copy themes directory
    cp -r themes $out/

    # Copy documentation
    cp README.md $out/
    cp LICENSE.txt $out/

    runHook postInstall
  '';

  meta = {
    description = "Informative, fancy bash prompt for Git users";
    homepage = "https://github.com/magicmonty/bash-git-prompt";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
}
