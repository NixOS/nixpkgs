{ stdenv
, fetchFromGitHub
, dmd
, pkgconfig
, curl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.3.12";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${version}";
    sha256 = "0605nb3blvnncjx09frg2liarrd6pw8ph5jhnh764qcx0hyxcgs6";
  };

  nativeBuildInputs = [
    dmd
    pkgconfig
  ];
  buildInputs = [
    curl
    sqlite
  ];
  meta = with stdenv.lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar srgom ];
    platforms = platforms.linux;
  };
}
