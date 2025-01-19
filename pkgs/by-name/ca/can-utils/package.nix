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

  meta = {
    description = "CAN userspace utilities and tools (for use with Linux SocketCAN)";
    homepage = "https://github.com/linux-can/can-utils";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bjornfor
      Luflosi
    ];
  };
}
