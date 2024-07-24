{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "dbd";
  version = "1.50-unstable-2016-01-04";

  src = fetchFromGitHub {
    owner = "gitdurandal";
    repo = "dbd";
    rev = "8cf5350781b6753fcdd863148a5dcc6976e693ca";
    hash = "sha256-b2yBZ2/Ab+SviKNlyZgdfiZ7GGZ1sonZnblD0i+vuFw=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
  ] ++ lib.optionals stdenv.isDarwin [ "darwin" ] ++ lib.optionals (stdenv.hostPlatform.isUnix && !stdenv.isDarwin) [ "unix" ];

  meta = with lib; {
    description = "Netcat-clone, designed to be portable and offer strong encryption";
    mainProgram = "dbd";
    homepage = "https://github.com/gitdurandal/dbd";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
