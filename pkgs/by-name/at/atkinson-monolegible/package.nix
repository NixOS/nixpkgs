{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-monolegible";
  version = "0-unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "Hylian";
    repo = "atkinson-monolegible";
    rev = "4d0e404118dece699ca926c310588316bfcd5ac2";
    hash = "sha256-U09ysphpDjXG/OwPxQDUiLHAYHGfiY+lL4+QIQLPj74=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 AtkinsonMonolegible.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Hylian/atkinson-monolegible";
    description = "Mono variant of the Atkinson Hyperlegible typeface";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
}
