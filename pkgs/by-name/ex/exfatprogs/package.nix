{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  file,
}:

stdenv.mkDerivation rec {
  pname = "exfatprogs";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    rev = version;
    sha256 = "sha256-EENBlf5beuLJ++N7YThxzz2I/FXzb02by3KOUPOuEV4=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

  meta = with lib; {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
