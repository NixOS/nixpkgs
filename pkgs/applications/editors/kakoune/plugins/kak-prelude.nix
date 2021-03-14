{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-prelude";
  version = "2020-06-09";

  src = fetchFromGitHub {
    owner = "alexherbo2";
    repo = "prelude.kak";
    rev = "f1e0f4d5cb62a36924e3f8ba6824d6aed8c19d23";
    sha256 = "1pncr8azqvl2z9yvzhc68p1s9fld8cvak8yz88zgrp5ypx2cxl8c";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/prelude
  '';

  meta = with lib;
  { description = "Prelude of shell blocks for Kakoune.";
    homepage = "https://github.com/alexherbo2/prelude.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ buffet ];
    platform = platforms.all;
  };
}
