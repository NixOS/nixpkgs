{ lib
, stdenv
, fetchFromGitHub
, readline
, bc
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "bcal";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "sha256-1k8Q+I1Mc196QL+x4yXzRi7WLBf30U4sJyl0rXisW7k=";
  };

  buildInputs = [ readline ];

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  checkInputs = [ bc python3Packages.pytestCheckHook ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    description = "Storage conversion and expression calculator";
    homepage = "https://github.com/jarun/bcal";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
