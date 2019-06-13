{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
    version = "2.3";
    name = "weather-${version}";

    src = fetchurl {
        url = "http://fungi.yuggoth.org/weather/src/${name}.tar.xz";
        sha256 = "0inij30prqqcmzjwcmfzjjn0ya5klv18qmajgxipz1jr3lpqs546";
    };

    nativeBuildInputs = [ pythonPackages.wrapPython ];

    buildInputs = [ pythonPackages.python ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
        site_packages=$out/${pythonPackages.python.sitePackages}
        mkdir -p $out/{share/{man,weather-util},bin,etc} $site_packages
        cp weather $out/bin/
        cp weather.py $site_packages/
        chmod +x $out/bin/weather
        cp airports overrides.{conf,log} places slist stations zctas zlist zones $out/share/weather-util/
        cp weatherrc $out/etc
        cp weather.1 weatherrc.5 $out/share/man/
        sed -i \
          -e "s|/etc|$out/etc|g" \
          -e "s|else: default_setpath = \".:~/.weather|&:$out/share/weather-util|" \
          $site_packages/weather.py
        wrapPythonPrograms
    '';

    meta = {
        homepage = http://fungi.yuggoth.org/weather;
        description = "Quick access to current weather conditions and forecasts";
        license = stdenv.lib.licenses.isc;
        maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
        platforms = with stdenv.lib.platforms; linux; # my only platform
    };
}
