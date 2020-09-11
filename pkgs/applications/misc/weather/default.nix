{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
    version = "2.4.1";
    pname = "weather";

    src = fetchurl {
        url = "http://fungi.yuggoth.org/weather/src/${pname}-${version}.tar.xz";
        sha256 = "0nf680dl7a2vlgavdhj6ljq8a7lkhvr6zghkpzad53vmilxsndys";
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

    meta = with stdenv.lib; {
        homepage = "http://fungi.yuggoth.org/weather";
        description = "Quick access to current weather conditions and forecasts";
        license = licenses.isc;
        maintainers = [ maintainers.matthiasbeyer ];
        platforms = platforms.linux; # my only platform
    };
}
