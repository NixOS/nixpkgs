{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ffmpeg,
  vlc,
  jq,
}:

stdenv.mkDerivation {
  pname = "gopro-tool";
  version = "0-unstable-2024-04-18";

  src = fetchFromGitHub {
    owner = "juchem";
    repo = "gopro-tool";
    rev = "a678f0ea65e24dca9b8d848b245bd2d487d3c8ca";
    sha256 = "0sh3s38m17pci24x4kdlmlhn0gwgm28aaa6p7qs16wysk0q0h6wz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/gopro-tool $out/bin/gopro-tool
    chmod +x $out/bin/gopro-tool

    wrapProgram $out/bin/gopro-tool \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          vlc
          jq
        ]
      }
  '';

  meta = {
    description = "Tool to control GoPro webcam mode in Linux (requires v4l2loopback kernel module and a firewall rule)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ZMon3y ];
    platforms = lib.platforms.linux;
  };
}
