{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  txt2man,
  which,
}:

stdenv.mkDerivation rec {
  pname = "retry";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "minfrin";
    repo = "retry";
    rev = "${pname}-${version}";
    hash = "sha256-zUkOESB8UAt/i5koLq54FUeMHkjzFxaTHpGfui7zD2g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    txt2man
    which
  ];

  meta = {
    homepage = "https://github.com/minfrin/retry";
    description = "Command wrapper that retries until the command succeeds";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gfrascadorio ];
    platforms = lib.platforms.all;
    mainProgram = "retry";
  };
}
