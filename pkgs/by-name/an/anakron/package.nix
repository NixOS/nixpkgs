{
  lib,
  stdenvNoCC,
  fetchzip,
  xorg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "anakron";
  version = "0.3.3";

  src = fetchzip {
    url = "https://github.com/molarmanful/ANAKRON/releases/download/v${version}/ANAKRON-release_v${version}.zip";
    hash = "sha256-l4MA3OsMnqPIBWKx3ZO5XnxjE0gnIGyAtsZe2z/9zrw=";
  };

  nativeBuildInputs = [ xorg.mkfontscale ];

  installPhase = ''
    runHook preInstall

    misc="$out/share/fonts/misc"
    install -D -m 644 *.{bdf,otb,pcf} -t "$misc"
    install -D -m 644 *.psfu -t "$out/share/consolefonts"
    install -D -m 644 *.ttf -t "$out/share/fonts/truetype"

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir "$misc"

    runHook postInstall
  '';

  meta = {
    description = "Thicc retrofuturistic bitmap font made for the modern screen";
    homepage = "https://github.com/molarmanful/ANAKRON";
    changelog = "https://github.com/molarmanful/ANAKRON/releases/tag/v${version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      ejiektpobehuk
    ];
  };
}
