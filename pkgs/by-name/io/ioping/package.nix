{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ioping";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "koct9i";
    repo = "ioping";
    rev = "v${version}";
    hash = "sha256-9lJEjns8ttjgI52ZXeWgL77GMd7o7IvefBJ5UH9y9ks=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Disk I/O latency measuring tool";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/koct9i/ioping";
    mainProgram = "ioping";
  };
}
