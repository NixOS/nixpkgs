{
  lib,
  stdenv,
  fetchFromGitLab,
  go-md2man,
  coreutils,
  substituteAll,
}:

stdenv.mkDerivation rec {
  pname = "brillo";
  version = "1.4.12";

  src = fetchFromGitLab {
    owner = "cameronnemo";
    repo = "brillo";
    rev = "v${version}";
    hash = "sha256-dKGNioWGVAFuB4kySO+QGTnstyAD0bt4/6FBVwuRxJo=";
  };

  patches = [
    (substituteAll {
      src = ./udev-rule.patch;
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [ go-md2man ];

  makeFlags = [
    "PREFIX=$(out)"
    "AADIR=$(out)/etc/apparmor.d"
  ];

  installTargets = [ "install-dist" ];

  meta = {
    description = "Backlight and Keyboard LED control tool";
    homepage = "https://gitlab.com/cameronnemo/brillo";
    mainProgram = "brillo";
    license = with lib.licenses; [
      gpl3
      bsd0
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.alexarice ];
  };
}
