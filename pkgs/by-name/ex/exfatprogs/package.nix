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
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-ZMtDQ+RCTV0gUAXhsgUfRQlqcseWhbWa1szWfmgpDFk=";
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
