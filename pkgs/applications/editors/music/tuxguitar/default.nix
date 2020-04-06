{ stdenv, fetchurl, swt, jdk, makeWrapper, alsaLib, jack2, fluidsynth, libpulseaudio }:

let metadata = assert stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux";
  if stdenv.hostPlatform.system == "i686-linux" then
    { arch = "x86"; sha256 = "27675c358db237df74d20e8676000c25a87b9de0bb0a6d1c325e8d6db807d296"; }
  else
    { arch = "x86_64"; sha256 = "298555a249adb3ad72f3aef72a124e30bfa01cd069c7b5d152a738140e7903a2"; };
in stdenv.mkDerivation rec {
  version = "1.5.2";
  pname = "tuxguitar";

  src = fetchurl {
    url = "mirror://sourceforge/tuxguitar/${pname}-${version}-linux-${metadata.arch}.tar.gz";
    sha256 = metadata.sha256;
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r dist lib share $out/
    cp tuxguitar.sh $out/bin/tuxguitar

    ln -s $out/dist $out/bin/dist
    ln -s $out/lib $out/bin/lib
    ln -s $out/share $out/bin/share

    wrapProgram $out/bin/tuxguitar \
      --set JAVA "${jdk}/bin/java" \
      --prefix LD_LIBRARY_PATH : "$out/lib/:${stdenv.lib.makeLibraryPath [ swt alsaLib jack2 fluidsynth libpulseaudio ]}" \
      --prefix CLASSPATH : "${swt}/jars/swt.jar:$out/lib/tuxguitar.jar:$out/lib/itext.jar"
  '';

  meta = with stdenv.lib; {
    description = "A multitrack guitar tablature editor";
    longDescription = ''
      TuxGuitar is a multitrack guitar tablature editor and player written
      in Java-SWT. It can open GuitarPro, PowerTab and TablEdit files.
    '';
    homepage = http://www.tuxguitar.com.ar/;
    license = licenses.lgpl2;
    maintainers = [ maintainers.ardumont ];
    platforms = platforms.linux;
  };
}
