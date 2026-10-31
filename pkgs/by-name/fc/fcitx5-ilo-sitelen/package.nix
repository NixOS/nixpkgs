{
  lib,
  stdenv,
  fetchFromGitHub,
  fcitx5,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "fcitx5-ilo-sitelen";
  version = "0-unstable-2023-2-14";

  src = fetchFromGitHub {
    owner = "0x182d4454fb211940";
    repo = "ilo-sitelen";
    rev = "42be249c27efc21173984bf538e94ba5bb130695";
    hash = "sha256-caQVPBPuZjOwbtcDhxAdmG7PHXe50OeSLkSBoCtMcrQ=";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fcitx5
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Input method for Sitelen Pona";
    homepage = "https://github.com/0x182d4454fb211940/ilo-sitelen";
    maintainers = with lib.maintainers; [ toadhog ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
}
