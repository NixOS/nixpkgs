{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, alsa-lib
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "callaudiod";
  version = "0.1.4";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mobian1";
    repo = pname;
    rev = version;
    sha256 = "sha256-71+9ALz55aqxXRBRwOcs9fwiQK31pJ9E72pGRmt0OkE=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    glib
  ];

  meta = with lib; {
    description = "Daemon for dealing with audio routing during phone calls";
    homepage = "https://gitlab.com/mobian1/callaudiod";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pacman99 tomfitzhenry ];
    platforms = platforms.linux;
  };
}
