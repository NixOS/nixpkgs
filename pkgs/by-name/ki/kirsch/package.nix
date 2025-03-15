{
  lib,
  stdenvNoCC,
  fetchzip,
  xorg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "kirsch";
  version = "0.2.6";

  src = fetchzip {
    url = "https://github.com/molarmanful/kirsch/releases/download/v${version}/kirsch-release_v${version}.zip";
    hash = "sha256-4JUj69qXYOcjOO2HCD37c1QnCL1HlJkofoN3YghgYUc=";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    runHook preInstall

    misc="$out/share/fonts/misc"
    install -D -m 644 fonts/*.{bdf,otb,pcf} -t "$misc"
    install -D -m 644 fonts/*.ttf -t "$out/share/fonts/truetype"

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$misc"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A versatile bitmap font with an organic flair";
    homepage = "https://github.com/molarmanful/kirsch";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
