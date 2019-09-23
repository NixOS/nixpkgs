{ stdenv
, fetchFromGitHub
, dmd
, pkgconfig
, curl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${version}";
    sha256 = "0fg2zzhhd1wl8z416px432xynx6whnzdamzdckc8rmm1cvghgb0f";
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
