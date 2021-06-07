{ lib
, stdenv
, fetchFromGitHub
, readline
, bc
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "bcal";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${version}";
    sha256 = "4vR5rcbNkoEdSRNoMH9qMHP3iWFxejkVfXNiYfwbo/A=";
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
