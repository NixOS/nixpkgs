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

  meta = with lib; {
    homepage = "https://github.com/minfrin/retry";
    description = "Command wrapper that retries until the command succeeds";
    license = licenses.asl20;
    maintainers = with maintainers; [ gfrascadorio ];
    platforms = platforms.all;
    mainProgram = "retry";
  };
}
