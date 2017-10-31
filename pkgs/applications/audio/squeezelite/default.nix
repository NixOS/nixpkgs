{ stdenv, fetchFromGitHub, alsaLib, faad2, flac, libmad, libvorbis, mpg123 }:

stdenv.mkDerivation {
  name = "squeezelite-git-2016-05-27";

  src = fetchFromGitHub {
    owner = "ralph-irving";
    repo = "squeezelite";
    rev = "e37ed17fed9e11a7346cbe9f1e1deeccc051f42e";
    sha256 = "15ihx2dbp4kr6k6r50g9q5npqad5zyv8nqf5cr37bhg964syvbdm";
  };

  buildInputs = [ alsaLib faad2 flac libmad libvorbis mpg123 ];

  installPhase = ''
    mkdir -p $out/bin
    cp squeezelite $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = https://github.com/ralph-irving/squeezelite;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
