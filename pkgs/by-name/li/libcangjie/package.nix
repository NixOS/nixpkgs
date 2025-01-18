{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  sqlite,
  cppcheck,
}:

stdenv.mkDerivation rec {
  pname = "libcangjie";
  version = "1.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "cangjie";
    repo = "libcangjie";
    rev = "v${version}";
    hash = "sha256-LZRU2hbAC8xftPAIHDKCa2SfFLuH/PVqvjZmOSoUQwc=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    sqlite
    cppcheck
  ];

  doCheck = true;

  meta = {
    description = "C library implementing the Cangjie input method";
    homepage = "https://gitlab.freedesktop.org/cangjie/libcangjie";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.linquize ];
    platforms = lib.platforms.all;
    mainProgram = "libcangjie-cli";
  };
}
