{
  stdenv,
  lib,
  meson,
  ninja,
  espeak-ng,
  fetchFromGitHub,
  pkg-config,
  ronn,
  alsa-lib,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "espeakup";
  version = "0.90";

  src = fetchFromGitHub {
    owner = "linux-speakup";
    repo = "espeakup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qjdg1kParsnpb8Lv51wXLdrLufxtbBTsP8B3t53islI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    ronn
  ];

  buildInputs = [
    espeak-ng
    alsa-lib
    systemd
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  meta = {
    homepage = "https://github.com/linux-speakup/espeakup";
    description = "Lightweight connector for espeak-ng and speakup";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethindp ];
    platforms = with lib.platforms; linux;
    mainProgram = "espeakup";
  };
})
