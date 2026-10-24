{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "baekmuk-ttf";
  version = "2.2";

  src = fetchurl {
    url = "http://kldp.net/baekmuk/release/865-baekmuk-ttf-${finalAttrs.version}.tar.gz";
    hash = "sha256-CKt9/7VdWIfMlCzjcPXjO3VqVfu06vC5DyRAcOjVGII=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/doc/baekmuk-ttf-${finalAttrs.version}  COPYRIGHT*

    runHook postInstall
  '';

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Korean font";
    homepage = "http://kldp.net/projects/baekmuk/";
    license = lib.licenses.baekmuk;
  };
})
