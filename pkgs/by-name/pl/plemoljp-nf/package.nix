{
  stdenvNoCC,
  fetchzip,
  plemoljp,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp-nf";

  # plemoljp's updateScript also updates this version.
  # nixpkgs-update: no auto update
  inherit (plemoljp) version;

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_NF_v${finalAttrs.version}.zip";
    hash = "sha256-m8zR9ySl88DnVzG4fKJtc9WjSLDMLU4YDX+KXhcP2WU=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 PlemolJPConsole_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-console
    install -Dm444 PlemolJP35Console_NF/*.ttf -t $out/share/fonts/truetype/plemoljp-nf-35console

    runHook postInstall
  '';

  meta = plemoljp.meta // {
    description = "Composite font of IBM Plex Mono, IBM Plex Sans JP and nerd-fonts";
  };
})
