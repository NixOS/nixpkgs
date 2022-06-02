{ lib, stdenv, fetchurl, swt, jre, makeWrapper, alsa-lib, jack2, fluidsynth, libpulseaudio }:

let metadata = assert stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux";
  if stdenv.hostPlatform.system == "i686-linux" then
    { arch = "x86"; sha256 = "sha256-k4FQrt72VNb5FdYMzxskcVhKlvx8MZelUlLCItxDB7c="; }
  else
    { arch = "x86_64"; sha256 = "sha256-mj5wVQlY2xFzdulvMdb5Qb5HGwr7RElzIkpOLjaAfGA="; };
in stdenv.mkDerivation rec {
  version = "1.5.5";
  pname = "tuxguitar";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}-linux-${metadata.arch}.tar.gz";
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r dist lib share $out/
    cp tuxguitar.sh $out/bin/tuxguitar

    ln -s $out/dist $out/bin/dist
    ln -s $out/lib $out/bin/lib
    ln -s $out/share $out/bin/share

    wrapProgram $out/bin/tuxguitar \
      --set JAVA "${jre}/bin/java" \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${lib.makeLibraryPath [ swt alsa-lib jack2 fluidsynth libpulseaudio ]}" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar:$out/lib/tuxguitar.jar:$out/lib/itext.jar"
  '';

  meta = with lib; {
    description = "A multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = "http://www.tuxguitar.com.ar/";
    license = licenses.lgpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
