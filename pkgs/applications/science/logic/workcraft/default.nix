{ stdenv, pkgs, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  name = "workcraft-${version}";
  version = "3.1.9";

  src = fetchurl {
    url = "https://github.com/workcraft/workcraft/releases/download/v${version}/workcraft-v${version}-linux.tar.gz";
    sha256 = "0d1mi8jffwr7irp215j9rfpa3nmwxrx6mv13bh7vn0qf6i0aw0xi";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
  mkdir -p $out/share
  cp -r * $out/share
  mkdir $out/bin
  makeWrapper $out/share/workcraft $out/bin/workcraft \
    --set JAVA_HOME "${jre}" \
    --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=gasp';
  '';

  meta = {
    homepage = http://workcraft.org/;
    description = "Framework for interpreted graph modeling, verification and synthesis";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ timor ];
    inherit version;
  };
}
