{
  check,
  fetchFromGitHub,
  lib,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtsm";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "libtsm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8db/amwcV1a5Ho0dymQxKtOFsTN6nLUnwSobuAowSwk=";
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [
    check
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    platforms = lib.platforms.linux;
  };
})
