{ stdenv, fetchFromGitHub, python3Packages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "bcal-${version}";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "0jdn46wzwq7yn3x6p1xyqarp52pcr0ghnfhkm7nyxv734g1abw7r";
  };

  nativeBuildInputs = [ python3Packages.pytest ];

  doCheck = true;
  checkPhase = ''
    python3 -m pytest test.py
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Storage conversion and expression calculator";
    homepage = https://github.com/jarun/bcal;
    license = licenses.gpl3;
    platforms = [ "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
