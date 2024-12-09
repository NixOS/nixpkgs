{ stdenv
, lib
, meson
, ninja
, espeak-ng
, fetchFromGitHub
, pkg-config
, ronn
, alsa-lib
, systemd
}:

stdenv.mkDerivation rec {
  pname = "espeakup";
  version = "0.90";

  src = fetchFromGitHub {
    owner = "linux-speakup";
    repo = "espeakup";
    rev = "v${version}";
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

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  meta = with lib; {
    homepage = "https://github.com/linux-speakup/espeakup";
    description = "Lightweight connector for espeak-ng and speakup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethindp ];
    platforms = with platforms; linux;
    mainProgram = "espeakup";
  };
}
