{ stdenv, fetchFromGitHub, dmd, pkgconfig, curl, sqlite, libnotify }:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "12cc1i6ygrky4dm42frlsysyjn74qjqg9w19m17fgblagdh66q04";
  };

  nativeBuildInputs = [ dmd pkgconfig ];

  buildInputs = [ curl sqlite libnotify ];

  configureFlags = [ "--enable-notifications" ];

  meta = with stdenv.lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3;
    maintainers = with maintainers; [ srgom ianmjones ];
    platforms = platforms.linux;
  };
}
