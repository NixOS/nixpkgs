{ lib, stdenv, fetchFromGitHub, cmake, libbfd, SDL2, obs-studio
, looking-glass-client }:

stdenv.mkDerivation {
  pname = "looking-glass-obs";
  version = looking-glass-client.version;

  src = looking-glass-client.src;

  sourceRoot = "source/obs";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ obs-studio libbfd SDL2 ];

  NIX_CFLAGS_COMPILE = "-mavx";

  installPhase = ''
    mkdir -p $out/lib/obs-plugins/
    mv liblooking-glass-obs.so $out/lib/obs-plugins/
  '';

  meta = with lib; {
    description = "Plugin for OBS Studio for efficient capturing of looking-glass";
    homepage = "https://looking-glass.io/docs/stable/obs/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
}
