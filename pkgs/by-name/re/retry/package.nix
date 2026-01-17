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
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "minfrin";
    repo = "retry";
    rev = "${pname}-${version}";
    hash = "sha256-26sSjz4UE7TVP66foVhDFTNNzdh/6OY6CaFS/544RQU=";
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
