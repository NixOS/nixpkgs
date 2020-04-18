{ stdenv, fetchFromGitHub, dmd, pkgconfig, curl, sqlite, libnotify }:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.3.13";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bcsrfh1g7bdlcp0zjn6np88qzpn5frv61lzxz9b2ayxf7wyybvi";
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
