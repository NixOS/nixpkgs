{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  gtklock,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtklock-powerbar-module";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = "gtklock-powerbar-module";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7pp1t49BWRluRTL28ti+Nx7n7ip4sDphIOR6TMnFh5M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  postPatch =
    let
      systemctl = lib.getExe' systemd "systemctl";
    in
    ''
      substituteInPlace source.c \
        --replace-fail '"systemctl reboot"' '"${systemctl} reboot"' \
        --replace-fail '"systemctl -i poweroff"' '"${systemctl} -i poweroff"' \
        --replace-fail '"systemctl suspend"' '"${systemctl} suspend"'
    '';

  passthru.tests.testModule = gtklock.testModule finalAttrs.finalPackage;

  meta = {
    description = "Gtklock module adding power controls to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-powerbar-module";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
