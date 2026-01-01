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

stdenv.mkDerivation rec {
  pname = "nwipe";
  version = "0.39";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
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

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Securely erase disks";
    mainProgram = "nwipe";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      vifino
      woffs
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
