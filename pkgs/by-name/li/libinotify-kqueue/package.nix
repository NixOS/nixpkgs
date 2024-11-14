{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libinotify-kqueue";
  version = "20180201";

  src = fetchFromGitHub {
    owner = "libinotify-kqueue";
    repo = "libinotify-kqueue";
    rev = version;
    sha256 = "sha256-9A5s8rPGlRv3KbxOukk0VB2IQrDxVjklO5RB+IA1cDY=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;
  checkFlags = [ "test" ];

  meta = with lib; {
    description = "Inotify shim for macOS and BSD";
    homepage = "https://github.com/libinotify-kqueue/libinotify-kqueue";
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; darwin ++ freebsd ++ netbsd ++ openbsd;
  };
}
