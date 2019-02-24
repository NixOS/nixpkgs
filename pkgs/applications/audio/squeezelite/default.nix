{ stdenv, fetchFromGitHub, alsaLib, faad2, flac, libmad, libvorbis, mpg123 }:

stdenv.mkDerivation {
  name = "squeezelite-git-2018-08-14";

  src = fetchFromGitHub {
    owner  = "ralph-irving";
    repo   = "squeezelite";
    rev    = "ecb6e3696a42113994640e5345d0b5ca2e77d28b";
    sha256 = "0di3d5qy8fhawijq6bxy524fgffvzl08dprrws0fs2j1a70fs0fh";
  };

  buildInputs = [ alsaLib faad2 flac libmad libvorbis mpg123 ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin                   squeezelite
    install -Dm644 -t $out/share/doc/squeezelite *.txt *.md

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = https://github.com/ralph-irving/squeezelite;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
