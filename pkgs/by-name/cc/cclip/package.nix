{
  stdenv,
  lib,
  meson,
  ninja,
  wayland,
  wayland-scanner,
  pkg-config,
  fetchFromGitHub,
  gitMinimal,
  xxHash,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cclip";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "heather7283";
    repo = "cclip";
    rev = finalAttrs.version;
    sha256 = "sha256-rjDCYag0aG9mZuwzWNS5z/CzeEtpdjc9iMypKqIZK60=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    gitMinimal
  ];

  buildInputs = [
    wayland
    sqlite
    xxHash
  ];

  meta = {
    description = "clipboard manager for wayland";
    homepage = "https://github.com/heather7283/cclip";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "cclip";
    maintainers = with lib.maintainers; [ rootrim ];
  };
})
