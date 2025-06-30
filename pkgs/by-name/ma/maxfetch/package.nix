{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  gnused,
  ncurses,
  procps,
}:

stdenvNoCC.mkDerivation {
  pname = "maxfetch";
  version = "unstable-2023-07-31";

  src = fetchFromGitHub {
    owner = "jobcmax";
    repo = "maxfetch";
    rev = "17baa4047073e20572403b70703c69696af6b68d";
    hash = "sha256-LzOhrFFjGs9GIDjk1lUFKhlnzJuEUrKjBcv1eT3kaY8=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 maxfetch $out/bin/maxfetch
    wrapProgram $out/bin/maxfetch \
     --prefix PATH : ${
       lib.makeBinPath [
         gnused
         ncurses
         procps
       ]
     }
    runHook postInstall
  '';

  meta = with lib; {
    description = "Nice fetching program written in sh";
    homepage = "https://github.com/jobcmax/maxfetch";
    license = licenses.gpl2Plus;
    mainProgram = "maxfetch";
    maintainers = with maintainers; [ jtbx ];
    platforms = platforms.unix;
  };
}
