{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, wlroots
, libevdev
}:

stdenv.mkDerivation rec {
  pname = "wf-config";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-config";
    rev = version;
    sha256 = "100b78wvnb3qwd2lrhnh5d0llvn71lfjpkjryry5gbz5v20a63z7";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    wlroots
    libevdev
  ];

  meta = with stdenv.lib; {
    description = "A library for managing configuration files, written for wayfire";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Thra11 ];
  };
}
