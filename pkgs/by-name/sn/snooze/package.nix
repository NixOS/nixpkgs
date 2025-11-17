{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "snooze";
  version = "0.5.1";
  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "snooze";
    rev = "v${version}";
    sha256 = "sha256-ghWQ/bslWJCcsQ8OqS3MHZiiuGzbgzat6mkG2avSbEk=";
  };
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = with lib; {
    description = "Tool for waiting until a particular time and then running a command";
    maintainers = with maintainers; [ kaction ];
    license = licenses.cc0;
    platforms = platforms.unix;
    mainProgram = "snooze";
  };
}
