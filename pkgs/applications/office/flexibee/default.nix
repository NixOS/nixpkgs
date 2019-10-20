{ stdenv, fetchurl, makeWrapper, jre }:

let
  version = "2019.3.0.3";
  majorVersion = builtins.substring 0 6 version;
in

stdenv.mkDerivation rec {
  pname = "flexibee";
  inherit version;

  src = fetchurl {
    url = "http://download.flexibee.eu/download/${majorVersion}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1ivhqh1rl4ll0af9nfgfm7f647vc9zk61aplinvz73xb3grb4j6f";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    cp -R usr/share/flexibee/ $out/
    install -Dm755 usr/bin/flexibee $out/bin/flexibee
    wrapProgram  $out/bin/flexibee --set JAVA_HOME "${jre}"
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
