{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "can-utils";
  version = "2023.03";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "can-utils";
    rev = "v${version}";
    hash = "sha256-FaopviBJOmO0lXoJcdKNdtsoaJ8JrFEJGyO1aNBv+Pg=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "CAN userspace utilities and tools (for use with Linux SocketCAN)";
    homepage = "https://github.com/linux-can/can-utils";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      bjornfor
      Luflosi
    ];
  };
}
