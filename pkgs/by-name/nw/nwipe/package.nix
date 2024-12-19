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
  version = "0.37";

  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "sha256-0mBiWKkMV8i9n158k843caulF90k43ctpMvKhc4HZxY";
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
  };
}
