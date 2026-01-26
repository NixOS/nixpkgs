{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "snooze";
  version = "0.5.1";
  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "snooze";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ghWQ/bslWJCcsQ8OqS3MHZiiuGzbgzat6mkG2avSbEk=";
  };
  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = {
    description = "Tool for waiting until a particular time and then running a command";
    maintainers = with lib.maintainers; [ kaction ];
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
    mainProgram = "snooze";
  };
})
