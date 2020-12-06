{ stdenv, fetchurl, makeWrapper, jre }:

let
  version = "2020.2.6";
  majorVersion = builtins.substring 0 6 version;
in

stdenv.mkDerivation rec {
  pname = "flexibee";
  inherit version;

  src = fetchurl {
    url = "http://download.flexibee.eu/download/${majorVersion}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0vscz24sabk9xafywnx41rqhq6300ddsw1x95ibc7ghsgbkq80ja";
  };

  nativeBuildInputs = [ makeWrapper ];

  prePatch = ''
    substituteInPlace usr/sbin/flexibee-server \
      --replace "/usr/share/flexibee" $out \
      --replace "/var/run" "/run"
  '';


  installPhase = ''
    runHook preInstall
    cp -R usr/share/flexibee/ $out/
    install -Dm755 usr/bin/flexibee $out/bin/flexibee
    install -Dm755 usr/sbin/flexibee-server $out/bin/flexibee-server
    wrapProgram $out/bin/flexibee --set JAVA_HOME "${jre}"
    wrapProgram $out/bin/flexibee-server --set JAVA_HOME "${jre}"
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Client for an accouting economic system";
    homepage = "https://www.flexibee.eu/";
    license = licenses.unfree;
    maintainers = [ maintainers.mmahut ];
    platforms = [ "x86_64-linux" ];
  };
}
