{ stdenv, fetchFromGitHub, dmd, pkgconfig, curl, sqlite, libnotify }:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cswiwwbkdjnx0bd4hz5d6w20k0b4074a37qmcgyifwzl5qfx09q";
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
