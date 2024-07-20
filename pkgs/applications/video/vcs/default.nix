{ lib, stdenv, fetchurl, makeWrapper
, coreutils, ffmpeg, gawk, gnugrep, gnused, imagemagick, mplayer
, util-linux, getopt
, dejavu_fonts
}:
with lib;
let
  version = "1.13.4";
  gopt = if stdenv.isLinux then util-linux else getopt;
  runtimeDeps = [
    coreutils ffmpeg gawk gnugrep gnused imagemagick mplayer gopt
  ];
in
stdenv.mkDerivation {
  pname = "vcs";
  inherit version;
  src = fetchurl {
    url = "http://p.outlyer.net/files/vcs/vcs-${version}.bash";
    sha256 = "0nhwcpffp3skz24kdfg4445i6j37ks6a0qsbpfd3dbi4vnpa60a0";
  };

  unpackCmd = "mkdir src; cp $curSrc src/vcs";
  patches = [ ./fonts.patch ];
  nativeBuildInputs = [ makeWrapper ];

  inherit dejavu_fonts;
  installPhase = ''
    mkdir -p $out/bin
    mv vcs $out/bin/vcs
    substituteAllInPlace $out/bin/vcs
    chmod +x $out/bin/vcs
    wrapProgram $out/bin/vcs --argv0 vcs --set PATH "${makeBinPath runtimeDeps}"
  '';

  meta = {
    description = "Generates contact sheets from video files";
    homepage = "http://p.outlyer.net/vcs";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ elitak ];
    platforms = with platforms; unix;
    mainProgram = "vcs";
  };
}
