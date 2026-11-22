{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inconsolata-lgc";
  version = "3.420";

  src = fetchzip {
    url = "https://github.com/MihailJP/Inconsolata-LGC/releases/download/v${finalAttrs.version}/InconsolataLGC-FullTTF-${finalAttrs.version}.tar.xz";
    hash = "sha256-2Y05H+hoGAcTPFiFHTntvjAF5vVwe3QRr/3cfjjdAlc=";
  };

  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${finalAttrs.pname} ChangeLog OFL.txt README.md
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fork of Inconsolata font, with proper support of Cyrillic and Greek";
    longDescription = ''
      Inconsolata is one of the most suitable font for programmers created by Raph
      Levien. Since the original Inconsolata does not contain Cyrillic alphabet,
      it was slightly inconvenient for not a few programmers from Russia.

      Inconsolata LGC is a modified version of Inconsolata with added the Cyrillic
      alphabet which directly descends from Inconsolata Hellenic supporting modern
      Greek.

      Inconsolata LGC is licensed under SIL OFL.


      Inconsolata LGC changes:
      * Cyrillic glyphs added.
      * Italic and Bold font added.

      Changes inherited from Inconsolata Hellenic:
      * Greek glyphs.

      Changes inherited from Inconsolata-dz:
      * Straight quotation marks.
    '';
    license = lib.licenses.ofl;
    changelog = "https://github.com/MihailJP/Inconsolata-LGC/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/MihailJP/Inconsolata-LGC";
    maintainers = with lib.maintainers; [
      avnik
      talal
    ];
    platforms = lib.platforms.all;
  };
})
