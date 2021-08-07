{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "workcraft";
  version = "3.3.2";

  src = fetchurl {
    url = "https://github.com/workcraft/workcraft/releases/download/v${version}/workcraft-v${version}-linux.tar.gz";
    sha256 = "0v71x3fph2j3xrnysvkm7zsgnbxisfbdfgxzvzxxfdg59a6l3xid";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  installPhase = ''
  mkdir -p $out/share
  cp -r * $out/share
  mkdir $out/bin
  makeWrapper $out/share/workcraft $out/bin/workcraft \
    --set JAVA_HOME "${jre}" \
    --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=gasp';
  '';

  meta = {
    homepage = "https://workcraft.org/";
    description = "Framework for interpreted graph modeling, verification and synthesis";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timor ];
  };
}
