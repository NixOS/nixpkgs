{
  lib,
  freeipmi,
  autoreconfHook,
  pkg-config,
  fetchFromGitHub,
  tcp_wrappers,
  stdenv,
  expect,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "conman";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "conman";
    tag = "conman-${finalAttrs.version}";
    hash = "sha256-CHWvHYTmTiEpEfHm3TF5aCKBOW2GsT9Vv4ehpj775NQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    freeipmi # For libipmiconsole.so.2
    tcp_wrappers # For libwrap.so.0
    expect # For conman/*.exp scripts
  ];

  meta = {
    description = "The Console Manager";
    homepage = "https://github.com/dun/conman";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      frantathefranta
    ];
  };

})
