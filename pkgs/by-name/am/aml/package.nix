{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "aml";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "aml";
    tag = "v${version}";
    sha256 = "sha256-BX+MRqvnwwLPhz22m0gfJ2EkW31KQEi/YTgOCMcQk2Q=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  meta = {
    description = "Another main loop";
    inherit (src.meta) homepage;
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
