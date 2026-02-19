{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  file,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exfatprogs";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "exfatprogs";
    repo = "exfatprogs";
    rev = finalAttrs.version;
    sha256 = "sha256-AwY5TkQRfWjkkcleymNN580mKGxIdZ0O30tt6yBbo5M=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    file
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "exFAT filesystem userspace utilities";
    homepage = "https://github.com/exfatprogs/exfatprogs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ yuannan ];
    platforms = lib.platforms.linux;
  };
})
