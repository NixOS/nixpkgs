{ stdenv, fetchFromGitHub, python3Packages, readline }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "bcal";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "0h6qi5rvzl6c6fsfdpdb3l4jcgip03l18i0b1x08z1y89i56y8mm";
  };

  nativeBuildInputs = [ python3Packages.pytest ];

  buildInputs = [ readline ];

  doCheck = true;
  checkPhase = ''
    python3 -m pytest test.py
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "Storage conversion and expression calculator";
    homepage = "https://github.com/jarun/bcal";
    license = licenses.gpl3;
    platforms = [ "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
