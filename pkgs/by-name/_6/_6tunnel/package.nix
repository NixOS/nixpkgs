{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "6tunnel";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "wojtekka";
    repo = "6tunnel";
    tag = version;
    sha256 = "sha256-ftTAFjHlXRrXH6co8bX0RY092lAmv15svZn4BKGVuq0=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Tunnelling for application that don't speak IPv6";
    mainProgram = "6tunnel";
    homepage = "https://github.com/wojtekka/6tunnel";
    changelog = "https://github.com/wojtekka/6tunnel/blob/${version}/ChangeLog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = lib.platforms.unix;
  };
}
