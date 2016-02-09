{ stdenv, fetchurl, pkgs }:

stdenv.mkDerivation rec {
    version = "2.0";
    name = "weather-${version}";

    src = fetchurl {
        url = "http://fungi.yuggoth.org/weather/src/${name}.tar.xz";
        sha256 = "0yil363y9iyr4mkd7xxq0p2260wh50f9i5p0map83k9i5l0gyyl0";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
        mkdir $out/{share,man,bin} -p
        cp weather{,.py} $out/bin/
        cp {airports,overrides.{conf,log},places,slist,stations,weatherrc,zctas,zlist,zones} $out/share/
        chmod +x $out/bin/weather
        cp ./weather.1 $out/man/
        cp ./weatherrc.5 $out/man/
    '';

    meta = {
        homepage = "http://fungi.yuggoth.org/weather";
        description = "Quick access to current weather conditions and forecasts";
        license = stdenv.lib.licenses.isc;
        maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
        platforms = with stdenv.lib.platforms; linux; # my only platform
    };
}
