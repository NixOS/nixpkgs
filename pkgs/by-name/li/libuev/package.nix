{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libuev";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "libuev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x1Sk7IuhlBQPFL7Rq4tmEanBxI/WaQ2L5fpUyEWOoi8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "Lightweight event loop library for Linux epoll() family APIs";
    homepage = "https://codedocs.xyz/troglobit/libuev/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ vifino ];
  };
})
