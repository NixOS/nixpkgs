{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "can-utils";
  version = "2025.01";

  src = fetchFromGitHub {
    owner = "linux-can";
    repo = "can-utils";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wum0hqPj3rCHHubNsOnj89tvrRQxoXrGQvZFcMKAGME=";
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
})
