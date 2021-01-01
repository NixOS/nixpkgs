{ stdenv, fetchFromGitHub, python3Packages, readline, bc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "bcal";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "4vR5rcbNkoEdSRNoMH9qMHP3iWFxejkVfXNiYfwbo/A=";
  };

  nativeBuildInputs = [ python3Packages.pytest ];

  buildInputs = [ readline ];

  doCheck = true;
  checkInputs = [ bc ];
  checkPhase = ''
    python3 -m pytest test.py
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Storage conversion and expression calculator";
    homepage = "https://github.com/jarun/bcal";
    license = licenses.gpl3Only;
    platforms = [ "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
