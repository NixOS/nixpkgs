{
  lib,
  stdenv,
  autoreconfHook,
  makeWrapper,
  fetchFromGitHub,
  ncurses,
  parted,
  pkg-config,
  libconfig,
  hdparm,
  smartmontools,
  dmidecode,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nwipe";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uWsN4DWzmipx/+gfMl8GXTg3pSKT0UPOkqVfdHfUPdA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    ncurses
    parted
    libconfig
  ];

  postInstall = ''
    wrapProgram $out/bin/nwipe \
      --prefix PATH : ${
        lib.makeBinPath [
          hdparm
          smartmontools
          dmidecode
        ]
      }
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Securely erase disks";
    mainProgram = "nwipe";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      vifino
      woffs
    ];
    platforms = lib.platforms.linux;
  };
})
