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
  version = "unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "ValleyBell";
    repo = "vgmplay-libvgm";
    rev = "813abab549e99bb7e936acbfa1199cf435c237c6";
    sha256 = "sdQO+xk3a7AFXo3jpbcuNBkd19PjKoBMRhr4IK06oHg=";
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
