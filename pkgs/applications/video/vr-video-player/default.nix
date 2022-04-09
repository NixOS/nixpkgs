{ stdenv, lib, fetchgit, pkg-config, gcc, glm, glew, SDL2, xlibsWrapper, xorg, openvr
, makeWrapper, steam-run }:

stdenv.mkDerivation rec {
  pname = "vr-video-player";
  version = "2022.03.23";

  src = fetchgit {
    url = "https://repo.dec05eba.com/vr-video-player";
    rev = "e6e1d14c01150872fea9198328d862127b4896b6";
    sha256 = "sha256-gkpncA/r/Vw/OZrqBWxyJw1y96OhTGVgtcj0+g0dTCc=";
  };

  buildInputs = [
    gcc
    pkg-config
    glm
    glew
    SDL2
    xlibsWrapper
    xorg.libXcomposite
    xorg.libXfixes
    openvr
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    substituteInPlace src/main.cpp \
      --replace "config/hellovr_actions.json" "$out/config/hellovr_actions.json"
    ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp vr-video-player $out/bin/.vr-video-player
    cp -ar config $out

    # Necessary because it will attempt to launch the SteamVR binary
    makeWrapper ${steam-run}/bin/steam-run $out/bin/vr-video-player \
      --add-flags $out/bin/.vr-video-player

  '';

  meta = with lib; {
    description = "A virtual reality video player for Linux running X11";
    license = licenses.bsd3;
    homepage = "https://git.dec05eba.com/vr-video-player";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
