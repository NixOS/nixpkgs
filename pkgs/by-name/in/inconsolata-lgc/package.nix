{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installFonts,
  ruby,
  ttfautohint-nox,
  nix-update-script,
  fontFormats ? [ ],
}:
let
  elemOrEmpty = item: list: builtins.elem item list || list == [ ];
in
lib.checkListOfEnum "fontFormats"
  [
    "ttf"
    "hintedttf"
    "otf"
    "ttc"
    "woff"
    "woff2"
    "variable"
  ]
  fontFormats
  stdenv.mkDerivation
  (finalAttrs: {
    pname = "inconsolata-lgc";
    version = "2.220";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "MihailJP";
      repo = "Inconsolata-LGC";
      tag = "LGC-${finalAttrs.version}";
      hash = "sha256-NNYcLWxWAykcxkRTUS1aE32fFuDJwmycpa9loytSGtw=";
    };

    nativeBuildInputs = [
      (python3.withPackages (
        p:
        [
          p.fontforge
          p.fontforge-ref-sel-util
        ]
        ++ lib.optionals (elemOrEmpty "variable" fontFormats) [ p.fontmake ]
        ++ lib.optionals (elemOrEmpty "ttc" fontFormats) [ p.fonttools ]
      ))
      installFonts
      ruby
      ttfautohint-nox
    ];

    postPatch = ''
      patchShebangs --build *.py *.rb
    '';

    enableParallelBuilding = true;
    buildFlags = fontFormats;

    dontInstallWebfonts = true;
    installPhase = ''
      runHook preInstall
      installFont woff $out/share/fonts/woff
      installFont woff2 $out/share/fonts/woff2
      install -m444 -Dt $out/share/doc/${finalAttrs.pname}-${finalAttrs.version} OFL.txt README.md
      runHook postInstall
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
      homepage = "https://github.com/MihailJP/Inconsolata-LGC";
      maintainers = with lib.maintainers; [
        avnik
      ];
    };
  })
