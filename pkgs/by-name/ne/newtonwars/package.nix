{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  libglut,
  libGLU,
  libGL,
}:

stdenv.mkDerivation {
  pname = "newtonwars";
  version = "unstable-2023-04-08";

  src = fetchFromGitHub {
    owner = "Draradech";
    repo = "NewtonWars";
    rev = "a32ea49f8f1d2bdb8983c28d24735696ac987617";
    hash = "sha256-qkvgQraYR+EXWUQkEvSOcbNFn2oRTjwj5U164tVto8M=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    libglut
    libGL
    libGLU
  ];

  patchPhase = ''
    sed -i "s;font24.raw;$out/share/font24.raw;g" display.c
  '';

  buildPhase = "sh build-linux.sh";

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp nw $out/bin
    cp font24.raw $out/share

    wrapProgram $out/bin/nw \
      --prefix LD_LIBRARY_PATH ":" ${libglut}/lib \
      --prefix LD_LIBRARY_PATH ":" ${libGLU}/lib \
      --prefix LD_LIBRARY_PATH ":" ${libGL}/lib
  '';

  meta = with lib; {
    description = "Space battle game with gravity as the main theme";
    mainProgram = "nw";
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
