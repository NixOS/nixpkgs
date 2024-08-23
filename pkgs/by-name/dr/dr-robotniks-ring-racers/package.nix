{
  clangStdenv,
  fetchgit,
  lib,
  cmake,
  zlib,
  curl,
  libpng,
  libogg,
  libvorbis,
  libvpx,
  libyuv,
  SDL2,
  makeWrapper,
  fetchzip,
}:
let
  pname = "dr-robotniks-ring-racers";
  version = "2.3";
  assets = fetchzip {
    curlOptsList = [ "-L" ];
    stripRoot = false;
    url = "https://github.com/KartKrewDev/RingRacers/releases/download/v${version}/Dr.Robotnik.s-Ring-Racers-v${version}-Assets.zip";
    hash = "sha256-sHeI1E6uNF0gBNd1e1AU/JT9wyZdkCQgYLiMPZqXAVc=";
  };
in
clangStdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    curl
    libpng
    libogg
    libvorbis
    libvpx
    libyuv
    SDL2
    makeWrapper
  ];

  src = fetchgit {
    url = "https://git.do.srb2.org/KartKrew/RingRacers.git";
    rev = "03241a13c5b22f567577c2cb06c4bbfb2f8e3cc9";
    hash = "sha256-X2rSwZOEHtnSJBpu+Xf2vkxGUAZSNSXi6GCuGlM6jhY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/bin "$out"/share/games
    install -Dm755 bin/ringracers "$out"/bin
    cp -R ${assets} "$out"/share/games/RingRacers

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.kartkrew.org/";
    description = "Dr. Robotnik’s Ring Racers is a Technical Kart Racer, drawing inspiration from antigrav racers, fighting games, and traditional-style kart racing.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.amadalusia ];
    platforms = lib.platforms.unix;
  };
}
