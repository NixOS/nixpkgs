{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "openscad.kak";
  version = "unstable-2019-11-08";

  src = fetchFromGitHub {
    owner = "mayjs";
    repo = "openscad.kak";
    rev = "d9143d5e7834e3356b49720664d5647cab9db7cc";
    sha256 = "0j4dqhrn56z77hdalfdxagwz8h6nwr8s9i4w0bs2644k72lsm2ix";
  };

  installPhase = ''
    install -Dm644 rc/openscad.kak -t $out/share/kak/autoload/plugins/
  '';

  meta = with lib; {
    description = "Syntax highlighting for OpenSCAD files";
    homepage = "https://github.com/mayjs/openscad.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ eraserhd ];
    platforms = platforms.all;
  };
}
