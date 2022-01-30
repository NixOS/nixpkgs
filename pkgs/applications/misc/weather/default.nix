{ lib, stdenv, fetchurl, python3, installShellFiles }:

stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "weather";

  src = fetchurl {
    url = "http://fungi.yuggoth.org/weather/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-qJl5rFDk31Fm+tmR6+Iiihcx6qyd9alHz2L672pNJsc=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3.pkgs.wrapPython
  ];

  dontConfigure = true;
  dontBuild = true;

  # Upstream doesn't provide a setup.py or alike, so we follow:
  # http://fungi.yuggoth.org/weather/doc/install.rst#id3
  installPhase = ''
    site_packages=$out/${python3.sitePackages}
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
