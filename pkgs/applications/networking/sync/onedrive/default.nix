{ stdenv
, fetchFromGitHub
, dmd
, pkgconfig
, curl
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.3.11";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = "onedrive";
    rev = "v${version}";
    sha256 = "08k5b3izqzk9mjjny5y47i3q5sl0w37xdqrhaacjxwm0jib9w0mh";
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
