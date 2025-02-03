{
  lib,
  fontforge,
  nerd-font-patcher,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inter-nerdfont";
  version = "4.0";

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${finalAttrs.version}/Inter-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-hFK7xFJt69n+98+juWgMvt+zeB9nDkc8nsR8vohrFIc=";
  };

  nativeBuildInputs = [
    fontforge
    nerd-font-patcher
  ];

  buildPhase = ''
    runHook preBuild
    nerd-font-patcher Inter.ttc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm444 'Inter Nerd Font.ttc' $out/share/fonts/truetype/InterNerdFont.ttc
    cp *.ttf $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    homepage = "https://gitlab.com/mid_os/inter-nerdfont";
    description = "NerdFont patch of the Inter font";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.midirhee12 ];
  };
})
