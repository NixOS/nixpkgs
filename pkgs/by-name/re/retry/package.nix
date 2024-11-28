{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, txt2man
, which
}:

stdenv.mkDerivation rec {
  pname = "retry";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "minfrin";
    repo = "retry";
    rev = "${pname}-${version}";
    hash = "sha256-5H2MnnThi4rT/o3oTkGDKXStQwob4G9mMsZewItPub4=";
  };

  nativeBuildInputs = [ autoreconfHook txt2man which ];

  meta = with lib; {
    homepage = "https://github.com/minfrin/retry";
    description = "Retry a command until the command succeeds";
    license = licenses.asl20;
    maintainers = with maintainers; [ gfrascadorio ];
    platforms = platforms.all;
    mainProgram = "retry";
  };
}

