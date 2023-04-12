{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, cmake
, pkg-config
, zlib
, libvgm
, inih
}:

stdenv.mkDerivation rec {
  pname = "vgmplay-libvgm";
  version = "unstable-2022-03-17";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "a2c21cb134b58043a013ac2efc060144cdecf13d";
    sha256 = "0g251laqjvvzblyflkg8xac424dbxm1v35ckfazsfchmcqiaqfw4";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ zlib libvgm inih ];

  postInstall = ''
    install -Dm644 ../VGMPlay.ini $out/share/vgmplay/VGMPlay.ini
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/ValleyBell/vgmplay-libvgm.git";
  };

  meta = with lib; {
    mainProgram = "vgmplay";
    homepage = "https://github.com/ValleyBell/vgmplay-libvgm";
    description = "New VGMPlay, based on libvgm";
    license = licenses.unfree; # no licensing text anywhere yet
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
