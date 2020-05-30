{ stdenv, fetchFromGitHub, dmd, pkgconfig, curl, sqlite, libnotify }:

stdenv.mkDerivation rec {
  pname = "onedrive";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "abraunegg";
    repo = pname;
    rev = "v${version}";
    sha256 = "10s33p1xzq9c5n1bxv9n7n31afxgx9i6c17w0xgxdrma75micm3a";
  };

  nativeBuildInputs = [ dmd pkgconfig ];

  buildInputs = [ curl sqlite libnotify ];

  configureFlags = [ "--enable-notifications" ];

  meta = with stdenv.lib; {
    description = "A complete tool to interact with OneDrive on Linux";
    homepage = "https://github.com/abraunegg/onedrive";
    license = licenses.gpl3;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
