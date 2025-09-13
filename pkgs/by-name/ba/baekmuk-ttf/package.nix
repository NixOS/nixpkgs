{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "baekmuk-ttf";
  version = "2.2";

  src = fetchurl {
    url = "http://kldp.net/baekmuk/release/865-${pname}-${version}.tar.gz";
    hash = "sha256-CKt9/7VdWIfMlCzjcPXjO3VqVfu06vC5DyRAcOjVGII=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts        ttf/*.ttf
    install -m444 -Dt $out/share/doc/${pname}-${version}  COPYRIGHT*

    runHook postInstall
  '';

  meta = {
    description = "Korean font";
    homepage = "http://kldp.net/projects/baekmuk/";
    license = lib.licenses.baekmuk;
  };
}
