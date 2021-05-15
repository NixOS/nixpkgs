{ lib, stdenv, fetchurl, pythonPackages, installShellFiles }:

stdenv.mkDerivation rec {
  version = "2.4.1";
  pname = "weather";

  src = fetchurl {
    url = "http://fungi.yuggoth.org/weather/src/${pname}-${version}.tar.xz";
    sha256 = "0nf680dl7a2vlgavdhj6ljq8a7lkhvr6zghkpzad53vmilxsndys";
  };

  nativeBuildInputs = [
    installShellFiles
    pythonPackages.wrapPython
  ];

  dontConfigure = true;
  dontBuild = true;

  # Upstream doesn't provide a setup.py or alike, so we follow:
  # http://fungi.yuggoth.org/weather/doc/install.rst#id3
  installPhase = ''
    site_packages=$out/${pythonPackages.python.sitePackages}
    install -Dt $out/bin -m 755 weather
    install -Dt $site_packages weather.py
    install -Dt $out/share/weather-util \
      airports overrides.{conf,log} places slist stations \
      zctas zlist zones
    install -Dt $out/etc weatherrc

    sed -i \
      -e "s|/etc|$out/etc|g" \
      -e "s|else: default_setpath = \".:~/.weather|&:$out/share/weather-util|" \
      $site_packages/weather.py

    wrapPythonPrograms

    installManPage weather.1 weatherrc.5
  '';

  meta = with lib; {
    homepage = "http://fungi.yuggoth.org/weather";
    description = "Quick access to current weather conditions and forecasts";
    license = licenses.isc;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
