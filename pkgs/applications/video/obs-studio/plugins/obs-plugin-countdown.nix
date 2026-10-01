{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-plugin-countdown";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ashmanix";
    repo = "obs-plugin-countdown";
    tag = finalAttrs.version;
    hash = "sha256-0E2pNRg4vwXK54aYuWYZyuRJaNrpwX7X0Dq6V8B/SgA=";
  };

  buildInputs = [
    obs-studio
    qt6.qtbase
  ];
  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    rm -rf "$out/obs-plugins" "$out/data"
  '';

  meta = {
    description = "OBS plugin that creates countdown timers";
    homepage = "https://github.com/ashmanix/obs-plugin-countdown";
    changelog = "https://github.com/ashmanix/obs-plugin-countdown/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
