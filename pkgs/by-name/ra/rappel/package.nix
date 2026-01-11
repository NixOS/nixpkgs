{
  lib,
  stdenv,
  fetchFromGitHub,
  libedit,
  makeWrapper,
  nasm,
}:

stdenv.mkDerivation {
  pname = "rappel";
  version = "0-unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "yrp604";
    repo = "rappel";
    rev = "981d8faf32b984e791841193498f46313fb6a56d";
    hash = "sha256-EnHNwasET3EdYjOQtvg4SDC9cWIA7RKP6xox3Ux9oRk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ libedit ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/rappel
    wrapProgram $out/bin/rappel --prefix PATH : "${nasm}/bin"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/yrp604/rappel";
    description = "Pretty janky assembly REPL";
    mainProgram = "rappel";
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.pamplemousse ];
    platforms = lib.platforms.linux;
  };
}
