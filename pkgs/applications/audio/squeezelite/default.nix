{ stdenv, fetchFromGitHub, alsaLib, faad2, flac, libmad, libvorbis, makeWrapper, mpg123 }:

let
  runtimeDeps  = [ faad2 flac libmad libvorbis mpg123 ];
  rpath = stdenv.lib.makeLibraryPath runtimeDeps;
in stdenv.mkDerivation {
  name = "squeezelite-git-2018-08-14";

  src = fetchFromGitHub {
    owner  = "ralph-irving";
    repo   = "squeezelite";
    rev    = "ecb6e3696a42113994640e5345d0b5ca2e77d28b";
    sha256 = "0di3d5qy8fhawijq6bxy524fgffvzl08dprrws0fs2j1a70fs0fh";
  };

  buildInputs = [ alsaLib ] ++ runtimeDeps;
  nativeBuildInputs = [ makeWrapper ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin                   squeezelite
    install -Dm644 -t $out/share/doc/squeezelite *.txt *.md

    wrapProgram $out/bin/squeezelite --set LD_LIBRARY_PATH $RPATH
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = https://github.com/ralph-irving/squeezelite;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
  RPATH = rpath;
}
