{ stdenv, fetchgit, pkg-config, gcc, glm, glew, SDL2, x11, xorg, openvr
, makeWrapper, steam-run }:

stdenv.mkDerivation rec {
  pname = "vr-video-player";
  version = "2020.07.28";

  src = fetchgit {
    url = "https://git.dec05eba.com/vr-video-player";
    rev = "9f104ba2f9ab2f05cc2d296cb1abbfd1011c6b25";
    sha256 = "0ayhp1sxpjd94xzzl1m1nz410al5j3hxkyzz4zcgccqnfwjbdqy0";
  };

  buildInputs = [
    gcc
    pkg-config
    glm
    glew
    SDL2
    x11
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

  meta = with stdenv.lib; {
    description = "A virtual reality video player for Linux running X11";
    license = licenses.bsd3;
    homepage = "https://git.dec05eba.com/vr-video-player";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
