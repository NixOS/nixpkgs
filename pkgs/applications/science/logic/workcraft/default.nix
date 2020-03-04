{ stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "workcraft";
  version = "3.2.5";

  src = fetchurl {
    url = "https://github.com/workcraft/workcraft/releases/download/v${version}/workcraft-v${version}-linux.tar.gz";
    sha256 = "11dk00b17yhk7cv8zms4nlffc0qwgsapimzr8csb89qmgabd7rj3";
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
    homepage = https://workcraft.org/;
    description = "Framework for interpreted graph modeling, verification and synthesis";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ timor ];
    inherit version;
  };
}
