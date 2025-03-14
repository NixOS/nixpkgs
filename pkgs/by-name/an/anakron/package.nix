{
  lib,
  stdenvNoCC,
  fetchzip,
  xorg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "anakron";
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/molarmanful/ANAKRON/releases/download/v${version}/ANAKRON-release_v${version}.zip";
    hash = "sha256-46sIPB0ox6atw+eic8JhssS3Y6qa+WbJQ3RX95BdYb4=";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    runHook preInstall

    d="$out/share/fonts/misc"
    find .  \( -name '*.bdf' -o -name '*.otb' -o -name '*.pcf' \) -exec install -m 644 -Dt $d {} \;
    find . -name '*.psfu' -exec install -m 644 -Dt $out/share/consolefonts {} \;
    find . -name '*.ttf' -exec install -m 644 -Dt $out/share/fonts/truetype {} \;

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$d"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A thicc retrofuturistic bitmap font made for the modern screen";
    homepage = "https://github.com/molarmanful/ANAKRON";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
