{
  lib,
  stdenv,
  qt5,
  fetchFromGitHub,
  fetchpatch,
  SDL,
  SDL_mixer,
  boost181,
  curl,
  gsasl,
  libgcrypt,
  libircclient,
  protobuf_21,
  sqlite,
  tinyxml,
  target ? "client",
}:

let
  boost = boost181;
  protobuf = protobuf_21;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pokerth-${target}";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "pokerth";
    repo = "pokerth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j4E3VMpaPqX7+hE3wYRZZUeRD//F+K2Gp8oPmJqX5FQ=";
  };

  patches = [
    (fetchpatch {
      name = "pokerth-1.1.2.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-we2UOCFF5J/Wlji/rJeCHDu/dNsUU+R+bTw83AmvDxs=";
    })
    (fetchpatch {
      name = "pokerth-1.1.2.patch.2019";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch.2019?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-m6uFPmPC3T9kV7EI1p33vQSi0d/w+YCH0dKjviAphMY=";
    })
    (fetchpatch {
      name = "pokerth-1.1.2.patch.2020";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/pokerth-1.1.2.patch.2020?h=pokerth&id=7734029cf9c6ef58f42ed873e1b9c3c19eb1df3b";
      hash = "sha256-I2qrgLGSMvFDHyUZFWGPGnuecZ914NBf2uGK02X/wOg=";
    })
  ];

  postPatch = ''
    for f in *.pro; do
      substituteInPlace $f \
        --replace '$$'{PREFIX}/include/libircclient ${libircclient.dev}/include/libircclient \
        --replace 'LIB_DIRS =' 'LIB_DIRS = ${boost.out}/lib' \
        --replace /opt/gsasl ${gsasl}
    done
  '';

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    SDL
    SDL_mixer
    boost
    curl
    gsasl
    libgcrypt
    libircclient
    protobuf
    qt5.qtbase
    sqlite
    tinyxml
  ];

  qmakeFlags = [
    "CONFIG+=${target}"
    "pokerth.pro"
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL";

  meta = {
    homepage = "https://www.pokerth.net";
    description = "Poker game ${target}";
    mainProgram = "pokerth";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ obadz ];
    platforms = lib.platforms.all;
  };
})
