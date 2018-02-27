{ stdenv, fetchFromGitHub, python3Packages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "bcal-${version}";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "08cqp2jysvy743gmwpzkbqhybsb49n65r63z3if53m3y59qg4aw8";
  };

  nativeBuildInputs = [ python3Packages.pytest ];

  doCheck = true;
  checkPhase = ''
    python3 -m pytest test.py
  '';

  makeFlags = [ "CC=cc" ];
  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Storage conversion and expression calculator";
    homepage = https://github.com/jarun/bcal;
    license = licenses.gpl3;
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
