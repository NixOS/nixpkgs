{
  lib,
  stdenvNoCC,
  fetchzip,
  xorg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "anakron";
  version = "0.3.1";

  src = fetchzip {
    url = "https://github.com/molarmanful/ANAKRON/releases/download/v${version}/ANAKRON-release_v${version}.zip";
    hash = "sha256-YggeGSFc+NoDUZjV/cEhQGUR278f97X+WpcDLY66iqg";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    runHook preInstall

    d="$out/share/fonts/misc"
    install -D -m 644 *.{bdf,otb,pcf} -t "$d"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -Dm644 *.ttf -t $out/share/fonts/truetype

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
