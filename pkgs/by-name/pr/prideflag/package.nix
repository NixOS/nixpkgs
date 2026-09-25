{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "prideflag";
  version = "0-unstable-2022-08-10";

  src = fetchFromGitHub {
    owner = "CharlotteCross1998";
    repo = "prideflags";
    rev = "968fd9a89b67bd1675da86ef955e728f828a6060";
    hash = "sha256-jiA9c+8VkaULLAFFrK+XF3VV/bRoKFm37iA9H3ZmZRA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 prideflag "$out/bin/prideflag"

    runHook postInstall
  '';

  meta = {
    description = "Print pride flags on the terminal!";
    homepage = "https://github.com/CharlotteCross1998/prideflags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emo-mruczek ];
    mainProgram = "prideflag";
  };
}
