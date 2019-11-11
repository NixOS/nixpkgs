{ stdenv
, fetchFromGitHub
, dmd
, pkgconfig
, curl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.3.10";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${version}";
    sha256 = "0ks22anxih63zwlc11z0gi531wvcricbkv1wlkrgfihi58l8fhfk";
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
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
