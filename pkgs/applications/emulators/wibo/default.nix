{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "wibo";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "decompals";
    repo = "WiBo";
    rev = version;
    sha256 = "sha256-zv+FiordPo7aho3RJqDEe/1sJtjVt6Vy665VeNul/Kw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Quick-and-dirty wrapper to run 32-bit windows EXEs on linux";
    longDescription = ''
      A minimal, low-fuss wrapper that can run really simple command-line
      32-bit Windows binaries on Linux - with less faff and less dependencies
      than WINE.
    '';
    homepage = "https://github.com/decompals/WiBo";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = [ "i686-linux" ];
  };
}
