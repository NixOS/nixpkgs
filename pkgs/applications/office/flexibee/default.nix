{ stdenv, fetchurl, makeWrapper, jre }:

let
  version = "2019.2.5";
  majorVersion = builtins.substring 0 6 version;
in

stdenv.mkDerivation rec {
  pname = "flexibee";
  inherit version;

  src = fetchurl {
    url = "http://download.flexibee.eu/download/${majorVersion}/${version}/${pname}-${version}.tar.gz";
    sha256 = "0k94y4x6lj1vcb89a95v9mzl95mkpwp9n4a2gwvq0g90zpbnn493";
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
