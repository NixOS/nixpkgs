{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  python3,
  openssh,
  rsync,
  findutils,
  which,
}:

stdenv.mkDerivation {
  pname = "bsync";
  version = "unstable-2023-12-21";

  src = fetchFromGitHub {
    owner = "dooblem";
    repo = "bsync";
    rev = "25f77730750720ad68b0ab2773e79d9ca98c3647";
    hash = "sha256-k25MjLis0/dp1TTS4aFeJZq/c0T01LmNcWtC+dw/kKY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm555 bsync -t $out/bin
    runHook postInstall
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  fixupPhase = ''
    runHook preFixup

    patchShebangs $out/bin/bsync
    wrapProgram $out/bin/bsync \
      --prefix PATH ":" ${
        lib.makeLibraryPath [
          openssh
          rsync
          findutils
          which
        ]
      }

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://github.com/dooblem/bsync";
    description = "Bidirectional Synchronization using Rsync";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dietmarw ];
    platforms = platforms.unix;
    mainProgram = "bsync";
  };
}
